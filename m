Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbYBFB6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbYBFB6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 20:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758793AbYBFB6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 20:58:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55251 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015AbYBFB6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 20:58:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Date: Wed, 6 Feb 2008 02:56:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
References: <20080205190600.GB11613@elf.ucw.cz> <200802060242.15097.rjw@sisk.pl> <47A9129A.7050706@zytor.com>
In-Reply-To: <47A9129A.7050706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060256.35870.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 6 of February 2008, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
> >> The asm() for making beeps really need to be moved to a function and 
> >> cleaned up (redone in C using inb()/outb()) if they are to be retained 
> >> at all.
> > 
> > Yes, they are.  For some people they're the only tool to debug broken resume.
> 
> That's fine, but they should get cleaned up.

I 100% agree.

> /me is tempted to provide a version which can send messages in Morse Code ;)

That would be great.  It could also play some music or something. ;-)

Rafael
