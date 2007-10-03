Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbXJCAJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbXJCAJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbXJCAJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:09:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45990 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752783AbXJCAJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:09:15 -0400
Date: Wed, 3 Oct 2007 01:10:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory
 Access   Control Kernel
Message-ID: <20071003011033.5bfc9165@the-village.bc.nu>
In-Reply-To: <4702B1D5.5050502@tmr.com>
References: <46FEEBD4.5050401@schaufler-ca.com>
	<20070930011618.ccb8351b.akpm@linux-foundation.org>
	<Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au>
	<alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org>
	<1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
	<alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
	<4702B1D5.5050502@tmr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 17:02:13 -0400
Bill Davidsen <davidsen@tmr.com> wrote:

> Linus Torvalds wrote:
> > 
> > On Mon, 1 Oct 2007, Stephen Smalley wrote:
> >> You argued against pluggable schedulers, right?  Why is security
> >> different?
> > 
> > Schedulers can be objectively tested. There's this thing called 
> > "performance", that can generally be quantified on a load basis.
> > 
> > Yes, you can have crazy ideas in both schedulers and security. Yes, you 
> > can simplify both for a particular load. Yes, you can make mistakes in 
> > both. But the *discussion* on security seems to never get down to real 
> > numbers. 
> > 
> And yet you can make the exact same case for schedulers as security, you 
> can quantify the behavior, but if your only choice is A it doesn't help 
> to know that B is better.

To be fair the discussion on security does get down to real set theory
but at that point most people's eyes (mine included) glaze over somewhat.

You can reasonably quantify the behaviour and correctness of a security
model based upon mathematical principles - if anything its *easier* that
schedulers which are so much based on "feeling right".

Smack seems a perfectly good simple LSM module, its clean, its based upon
credible security models and sound theory (unlike AppArmor). I don't see
why it shouldn't go in.

Alan
