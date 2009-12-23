Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbZLWUqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbZLWUqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 15:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZLWUqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 15:46:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52351 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZLWUqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 15:46:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [RFC] Asynchronous suspend/resume - test results
Date: Wed, 23 Dec 2009 21:46:29 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc1-tst; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>
References: <200912210140.19713.rjw@sisk.pl> <4B2F22EF.6040500@crca.org.au>
In-Reply-To: <4B2F22EF.6040500@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912232146.29339.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 December 2009, Nigel Cunningham wrote:
> Hi.
> 
> Rafael J. Wysocki wrote:
> > I'm not sure what the next step should be at this point.  To me, the picture is
> > quite clear now, but perhaps we ought to run more tests on some other machines
> > or something.  Please let me know what you think.
> 
> Looks great. If you do decide you want other machines tested, I'll
> happily try the machines around here:
> 
> - Dell M1530
> - Omnibook XE3-GF.
> - Via LN10000 based Mythtv Box
> - Desktop machine - Some Intel-based mobo I've forgotten the name of.

Yes, that would be useful.  If the results are in agreement with my data at
http://www.sisk.pl/kernel/data/, we will have a strong support for starting the
async threads upfront during resume. 

The patches I used for testing are in the async branch in my tree:
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git
The first of them is
http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=commit;h=91bbe0161cab7efcda5de3dfdf6a93f07314ed58
and the others are on top of this one (but it will apply on top of the current
mainline, so I'd suggest to pull the latest Linus' tree and then rebase the
commits from my async branch on top of it).

The "upfront * async" results were obtained with the full patchset applied.
The "sync" results where with /sys/power/pm_async = 0 and the "bare async"
results were with the last two commits reverted.
 
> By the way, I haven't forgotten about sending some real patches for
> swsusp (ie more than just cleanups). I'm just busy with other things and
> also thinking carefully about what order to do things in.

Great, I hope you're in contact with Jiri Slaby, as he's also been working on
this.

Rafael
