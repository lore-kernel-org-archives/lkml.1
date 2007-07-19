Return-Path: <linux-kernel-owner+w=401wt.eu-S936926AbXGSFtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936926AbXGSFtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 01:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbXGSFtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 01:49:22 -0400
Received: from mx10.go2.pl ([193.17.41.74]:42687 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752554AbXGSFtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 01:49:21 -0400
Date: Thu, 19 Jul 2007 07:58:20 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719055820.GA1679@ff.dom.local>
References: <20070716091236.GA10718@elte.hu> <200707172006.11664.olaf.kirch@oracle.com> <20070717181857.GA16918@elte.hu> <200707172034.20581.olaf.kirch@oracle.com> <20070718114820.GA1734@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718114820.GA1734@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 01:48:20PM +0200, Jarek Poplawski wrote:
...
> I'd be very glad if it could be verified and/or tested.

Jarek,

This patch is verified crap!

Regards,
Jarek P.

PS: Olaf,

You've written earlier that one of the main reasons for poll_napi is
to work when the kernel "doesn't even service softirqs anymore". But
in your patch poll_napi leaves netif_rx_complete for softirqs, so
even if it starts to work for Ingo in normal conditions, probably
something else is needed, anyway.
