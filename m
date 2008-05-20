Return-Path: <linux-kernel-owner+w=401wt.eu-S935297AbYETWnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935297AbYETWnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935107AbYETWjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:39:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765980AbYETWjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:39:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Subject: Re: [PATCH 0/4] Fix forcedeth hibernate/wake-on-lan problems
Date: Wed, 21 May 2008 00:39:36 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
References: <20080518125715.GA19229@yamamaya.is-a-geek.org> <20080518150908.GA4606@yamamaya.is-a-geek.org>
In-Reply-To: <20080518150908.GA4606@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805210039.37248.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 of May 2008, Tobias Diedrich wrote:
> Tobias Diedrich wrote:
> > Note that so far this is only tested on my system with hibernate
> > using the 'shutdown' method.
> 
> Ok, I've run tests now:
> 
> First Windoze:
> Windoze, Standby (equiv. to Linux 'mem' state):  WOL borked, resumes fine
> Windoze, Hibernate: WOL borked, resumes fine
> 
> Linux, unpatched:
> Hibernate, shutdown method: Works with known caveats
> Hibernate, platform method: WOL borked,

That may be worth some investigation.  However, since that doesn't work on
Windows too, I suspect the platform is slightly broken.

> resumes fine 
> 
> Linux, patched:
> Hibernate, shutdown method: Works
> Hibernate, platform method: WOL borked, resumes fine
> Suspend ('standby' state):
>    WOL borked, USB borked after resume, kernel freeze
> Suspend ('mem' state, text console):
>    WOL borked, VGA stays dark, otherwise working

You can try s2ram to bring the VGA to life, I think
(http://suspend.sf.net/s2ram-support.html).

> Suspend ('mem' state, radeonfb):
>    WOL borked, VGA stays dark, userspace dead after resume (but pingable)
> 
> Summary: I suspect my BIOS sucks

That's possible ...

>         Version: ASUS M2N-SLI DELUXE ACPI BIOS Revision 0903
>         Release Date: 02/13/2007
> 
> 1 point for Linux, 0 points for Windows, Linux wins ;)

Thanks,
Rafael
