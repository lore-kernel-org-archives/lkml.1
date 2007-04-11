Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbXDKOhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbXDKOhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXDKOhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:37:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37419 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbXDKOhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:37:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
Date: Wed, 11 Apr 2007 16:40:46 +0200
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
References: <460B6E4B.3060004@gmail.com> <200704111155.52455.rjw@sisk.pl> <461CBC3A.5090607@gmail.com>
In-Reply-To: <461CBC3A.5090607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704111640.47171.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 April 2007 12:45, Jiri Slaby wrote:
> Rafael J. Wysocki napsal(a):
> > On Wednesday, 11 April 2007 09:36, Jiri Slaby wrote:
> >> Rafael J. Wysocki napsal(a):
> >>> On Monday, 9 April 2007 22:07, Jiri Slaby wrote:
> >>>> I have bad news for you :(. I thought I had unpatched kernel, but it happens
> >>>> in -rc6 too.
> >>> I guess you mean you're still seeing the 'not enough memory to suspend'
> >>> problem?
> >> Yes:
> >> Disabling non-boot CPUs ...
> >> kvm: disabling virtualization on CPU1
> >> Breaking affinity for irq 9
> >> CPU 1 is now offline
> >> SMP alternatives: switching to UP code
> >> CPU1 is down
> >> swsusp: critical section:
> >> swsusp: Need to copy 158309 pages
> >> swsusp: Not enough free memory
> >> Error -12 suspending
> >> Enabling non-boot CPUs ...
> >> SMP alternatives: switching to SMP code
> >> Booting processor 1/2 APIC 0x1
> >> Initializing CPU#1
> > 
> > How reproducible is it?  I'm going to try to reproduce it on one of my boxes.
> 
> My tip is one of three cases: after some work on fresh boot -- some
> consumers such as thunderbird, firefox, 10 or so terminals with
> gnome-session. Single xterm + gnome-session semms not to be a problem.

Does the workaround with setting the image size below 1/2 of RAM work for you?

Rafael
