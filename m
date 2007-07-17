Return-Path: <linux-kernel-owner+w=401wt.eu-S934247AbXGQSfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbXGQSfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXGQSfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:35:38 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:34186 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbXGQSfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:35:37 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Tue, 17 Jul 2007 20:34:19 +0200
User-Agent: KMail/1.9.1
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
References: <20070716091236.GA10718@elte.hu> <200707172006.11664.olaf.kirch@oracle.com> <20070717181857.GA16918@elte.hu>
In-Reply-To: <20070717181857.GA16918@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172034.20581.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007 20:18, Ingo Molnar wrote:
> (one is HZ=100, the other HZ=1000. HZ=100 produces a hung network just 
> like HZ=250.)
> 
> no 'rx_sched set' messages in either case. Network still hung for 
> HZ=100, and is working for HZ=1000.

Is this from dmesg or the netconsole output? I don't see any Tx Unit
Hang messages from e1000 or netdev watchdog messages present in your
earlier dmesg logs. So maybe these messages are there, but never
get logged?

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
