Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbZJLVT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbZJLVT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbZJLVTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:19:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36097 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758274AbZJLVTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:19:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ondrej Hujnak <hujnak.ondrej@gmail.com>
Subject: Re: Suspend to RAM on MSI PR200YA - do not recover, system immediately turns down
Date: Mon, 12 Oct 2009 23:20:09 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mschmidt@redhat.com,
       pm list <linux-pm@lists.linux-foundation.org>
References: <37b436160910101054t7765c253ta98b983f226b57c3@mail.gmail.com> <200910102334.42399.rjw@sisk.pl> <37b436160910120849o6aae596w50e450b4838ed233@mail.gmail.com>
In-Reply-To: <37b436160910120849o6aae596w50e450b4838ed233@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122320.10059.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Ondrej Hujnak wrote:
> 2009/10/10 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Saturday 10 October 2009, Ondrej Hujnak wrote:
> >> Hello,
> >>
> >> I am trying to make work "Suspend to RAM".
> >> My laptop is MSI PR200YA, linux
> >> kernel 2.6.30.8-64.fc11.i586 (fedora 11, 32bit),
> >> the same is with 2.6.31.1-56.fc12.i686.
> >> Motherboard - MSI 1221, graphics:
> >> Mobile GM965/GL960 Integrated Graphics Controller
> >>
> >> When I do suspend to RAM it seem to work ok, it sleeps.
> >> But when I want to wake it, it only switches off (the power
> >> LED stops blinking).  If I'm having my notebook connected
> >> to electricity, after start it don't  start screen and keyboard.
> >> Notebook is running, but there is no HDD activity according
> >> to the LED indicator. When it is on battery, it normally starts,
> >> as if I had switched it normally off. Every time after trying to
> >> suspend it to RAM, on the next start I have
> >> "last write to superblock in future".
> >>
> >> I tried:
> >>  - suspend from "single" mode
> >>  - suspend from "single" mode with as many modules as possible rmmod'ed
> >>  - using "nomodeset"
> >>  - early suspend-to-RAM at boot test with "test_suspend=mem"
> >> All with the same result.
> >>
> >> I also tried using pm_trace, but this gave no useful results in dmesg
> >> in the next boot. The clock was not changed by it (the documentation
> >> said it would be).
> >>
> >> I have attached printout of "lspci -vv" and "dmesg" after switching
> >> pm_trace on.
> >>
> >> I'd welcome any ideas how to debug this further.
> >> I'm looking forward to your reply.
> >
> > Does the pm_test 'core' test work (please see
> > Documentation/power/basic-pm-debugging.txt)?
> >
> > Rafael
> >
> 
> Ok, i tried all kinds of pm_test including core several times
> and everything seemed ok. I got no error, failure..
> 
> And i tried all possibilities of /sys/power/disk under
>  "init=/bin/bash" and same result as above.

That seems to indicate some kind of a BIOS issue.  However, several suspend
bugs are going to be fixes in 2.6.32, so perhaps you can try -rc6 or later,
when they are out.

Thanks,
Rafael
