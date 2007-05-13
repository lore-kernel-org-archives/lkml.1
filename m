Return-Path: <linux-kernel-owner+w=401wt.eu-S1761151AbXEMXxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761151AbXEMXxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbXEMXxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:53:44 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53402 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbXEMXxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:53:43 -0400
Date: Sun, 13 May 2007 19:53:41 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] "volatile considered harmful" document
Message-ID: <20070513235341.GA4270@havoc.gtf.org>
References: <fa.UIDGHS72acFv9jKylmdQQwWcXPA@ifi.uio.no> <fa.fKNBJtZJWOQthlLjc1TDfY6jCLc@ifi.uio.no> <4646082D.2080502@shaw.ca> <m33b208z5f.fsf@maximus.localdomain> <46479E95.6050507@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46479E95.6050507@tmr.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 07:26:13PM -0400, Bill Davidsen wrote:
> Krzysztof Halasa wrote:
> >Robert Hancock <hancockr@shaw.ca> writes:
> >>You don't need volatile in that case, rmb() can be used.

> >rmb() invalidates all compiler assumptions, it can be much slower.

It does not invalidate /all/ assumptions.


> Yes, why would you use rmb() when a read of a volatile generates optimal 
> code?

Read of a volatile is guaranteed to generate the least optimal code.
That's what volatile does, guarantee no optimization of that particular
access.

	Jeff



