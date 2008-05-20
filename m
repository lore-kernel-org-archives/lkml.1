Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbYETAV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbYETAV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYETAVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:21:17 -0400
Received: from vena.lwn.net ([206.168.112.25]:54792 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYETAVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:21:17 -0400
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Jonathan Corbet" <corbet@lwn.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Alexander Viro" <viro@ftp.linux.org.uk>,
       "Arnd Bergmann" <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3, RFC] misc char dev BKL pushdown 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 19 May 2008 20:07:59 EDT."
             <8bd0f97a0805191707k597e4f48i9c54488777fdd91b@mail.gmail.com> 
Date: Mon, 19 May 2008 18:21:16 -0600
Message-ID: <30821.1211242876@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> this open func already has a spinlock protecting it.  doesnt that mean
> we dont need the bkl in it ?

The existence of a spinlock is a good sign.  But, until somebody has
looked at the code and verified that said lock is really protecting
everything, it's best to leave the BKL protection (which has always been
there, just at a higher level) in place.

jon
