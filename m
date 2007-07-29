Return-Path: <linux-kernel-owner+w=401wt.eu-S934809AbXG2TII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934809AbXG2TII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933301AbXG2THw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:07:52 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:60951 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130AbXG2THv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:07:51 -0400
X-Greylist: delayed 1355 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jul 2007 15:07:50 EDT
Date: Sun, 29 Jul 2007 14:45:00 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Frank Hale <frankhale@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com
Subject: Re: ACPI on Averatec 2370
In-Reply-To: <46ACD8DB.2020108@googlemail.com>
Message-ID: <Pine.LNX.4.64.0707291428100.7379@lancer.cnet.absolutedigital.net>
References: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com>
 <46ACD8DB.2020108@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007, Gabriel C wrote:

> Frank Hale wrote:
> [ added  linux-acpi to CC ]
> > I have an Averatec 2370 laptop with the nVidia MCP51. With kernel
> > 2.6.20 I had no issues with ACPI however with 2.6.21 and higher the
> > kernel will hang on boot until I press the suspend button or the power
> > button in which case the kernel wakes up and finishes the boot
> > process. Including the following support only causes the issue:
> > 
> >  [*] ACPI Support
> > 
> > What I mean by that is every ACPI option has been deactivated and only
> > ACPI support checked. The boot process with 2.6.21 and higher hangs at
> > the point where the Scheduler is being registered.
> > 
> > io scheduler cfq registered (default)
> > 
> > If I allow it to sit there it never comes back to life and finishes
> > booting. If I press the power or suspend button it will finish booting
> > as expected.
> > 
> > I've scoured google for quite a while but cannot find any relevant
> > information pertaining to this issue. For now I've disabled ACPI
> > altogether.

Hi Frank et al.

Same laptop (well 2371 actually - same hardware though), same issue. In my 
testing I've determined that SMP is influential on it hanging up. Building 
my same config with SMP disabled causes the hang to go away. Same with the 
Slackware 12 default kernels, 2.6.21.5 is OK, 2.6.21.5-smp hangs.

Frank, can you try a non-SMP build with ACPI and see if you still have the 
problem?

I've tried so many different option combos I don't remember if I've done 
one with SMP and w/o ACPI but I'll try that sometime today. Haven't tried 
ACPI debugging yet either so we'll see if that shows anything. Maybe we 
can narrow it down to something with ACPI and SMP.

Cheers,
-- 
Cal Peake

