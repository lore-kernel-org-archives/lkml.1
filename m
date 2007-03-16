Return-Path: <linux-kernel-owner+w=401wt.eu-S965898AbXCPUbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965898AbXCPUbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965903AbXCPUbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:31:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38612 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965898AbXCPUbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:31:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc4
Date: Fri, 16 Mar 2007 21:34:13 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-15?q?Fr=E9d=E9ric_RISS?= <frederic.riss@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>, Milan Broz <mbroz@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703162134.14265.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 16 March 2007 17:33, Linus Torvalds wrote:
> 
> I pushed out the -git trees yesterday, but then got distracted, so the 
> patches and tar-balls and the announcement got delayed until this morning. 
> Oops. I'm a scatter-brain.
> 
> Anyway, the good news about -rc4 is that there's just lots of random 
> fixes. I'm hoping that we've seriously cut down on the regression list, 
> and I'd ask everybody who is on Adrian's list to please re-verify their 
> regression, and in case it's one of the "patches available" ones but I 
> haven't merged (maybe because it hasn't been sent to me!), make sure I do.

I'm afraid that if CONFIG_TICK_ONESHOT or CONFIG_NO_HZ is set, we still have a
problem with RCU synchronization while nonboot CPUs are being enabled during a
resume (http://lkml.org/lkml/2007/3/11/144, http://lkml.org/lkml/2007/3/4/88).

Can someone who had this problem with -rc3 check if it's present in -rc4?

Thanks,
Rafael
