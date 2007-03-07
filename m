Return-Path: <linux-kernel-owner+w=401wt.eu-S965678AbXCGVs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965678AbXCGVs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965683AbXCGVs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:48:26 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60510 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965678AbXCGVsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:48:25 -0500
Date: Wed, 7 Mar 2007 13:48:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
In-Reply-To: <Pine.LNX.4.64.0703071329080.12756@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703071347380.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
 <20070307155553.06c82ca1.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com>
 <20070307233833.f1482f86.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com>
 <45EF20F7.1050307@goop.org> <Pine.LNX.4.64.0703071241590.12756@alien.or.mcafeemobile.com>
 <45EF2DFF.4060209@goop.org> <Pine.LNX.4.64.0703071329080.12756@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Davide Libenzi wrote:
> 
> You have the *choice* to do that:
> 
> 1) You want standard delivery only:
> 
>    - Just dont use signalfd
> 
> 2) you want signalfd only:
> 
>    - Do a sigprocmask(SIG_BLOCK) of the same mask you pass to signalfd
> 
> If you want both, you can have it. Race free.

.. but maybe with more code and lots of confusion. I'm still unclear on 
any upsides here. 

Choice is good, but only if it's *useful* choice.

		Linus
