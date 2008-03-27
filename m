Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbYC0Voc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbYC0Voc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbYC0VoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:44:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38746
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759959AbYC0VoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:44:08 -0400
Date: Thu, 27 Mar 2008 14:44:08 -0700 (PDT)
Message-Id: <20080327.144408.156087783.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: marcus@better.se, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       shemminger@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
 net_rx_action
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080327123248.GD2845@ami.dom.local>
References: <20080327.040334.25440988.davem@davemloft.net>
	<47EB8C06.4030306@better.se>
	<20080327123248.GD2845@ami.dom.local>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Thu, 27 Mar 2008 13:32:48 +0100

> On Thu, Mar 27, 2008 at 12:59:02PM +0100, Marcus Better wrote:
> > David Miller wrote:
> >> Can some test if using local_irq_{save,restore}() in
> >> napi_complete() cures this lockdep warning?
> 
> Isn't it now justified enough without lockdep's ack?

Absolutely, but I want to know that the problem is solved
and confirmed by a tester.
