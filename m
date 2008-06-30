Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbYF3EAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbYF3EAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 00:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYF3D75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 23:59:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:39817 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYF3D7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 23:59:55 -0400
Message-ID: <1d3f23370806292059qe407693h500d7e562b214e9a@mail.gmail.com>
Date: Mon, 30 Jun 2008 13:59:53 +1000
From: "John Williams" <john.williams@petalogix.com>
To: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
Subject: Re: [PATCH 12/60] microblaze_v4: Generic dts file for platforms
Cc: grant.likely@secretlab.ca, monstr@seznam.cz, linux-kernel@vger.kernel.org,
       arnd@arndb.de, linux-arch@vger.kernel.org,
       "John Linn" <linnj@xilinx.com>, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, "Michal Simek" <monstr@monstr.eu>
In-Reply-To: <20080630033943.332471860046@mail171-va3.bigfish.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
	 <fa686aa40806272249l7eae0c34k43a20ad41672b77a@mail.gmail.com>
	 <1d3f23370806291702g4344a2f9lb62f85cbb475fca4@mail.gmail.com>
	 <20080630033943.332471860046@mail171-va3.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

> In my opionion, we should only include dts files for reference designs, and
> it must be documented how to get the design that the dts corresponds to.

I'm not sure you (or Xilinx) are quite ready for the pain this implies
- have you tried browsing reference designs on Xilinx.com recently?
It's a total mishmash of tool versions, boards, you name it.  If
Xilinx is ready to declare a gold standard "ML401" design, and commit
to maintaining it tool version after tool version, lots of people will
be very happy, but I don't see it just yet!

I'm not having a go at you here, just questioning the notion that
there is really any such thing as a persistent 'reference design' for
these platforms.  These are not physical boards that get manufactured
and persist as real objects.

> MD5 hashing might be one way to prevent people from getting the dts file
> wrong, however without some way of checking it automatically, I don't think
> anyone will have the patience to checksum the design they have (even worse,
> with whitespace changes, the md5 sum will change, so this is pretty fragile.

Actually I was only joking about the md5 hashing - just to prove my point :)

> Having a device tree in the kernel for documentation *shouldn't* be
> necessary,

Well, yes and no.  A vanilla DTS that shows what a valid one might
look like - "oh, here's where I declare my main memory parameters,
..." has some value IMO.

> since noone should ever write their dts by hand. (right?)

I'm not certain you can guarantee that.

> Hence, I'd prefer to not put the dts file in the kernel at all, and but to
> automatically generate the dts and store it in the blockram of the design.
> This inextricably associates the dts with the design.

Whether the DTS lives in block ram or is pulled over the net by uboot
or whatever is not our call to make in the kernel - that's a
deployment issue.

> As for the copyright, I haven't been able to find much information on
> whether or not generated files are even copyrightable.  One might argue that
> they
> don't have sufficient 'creative value' to be copyrightable.  Or arguably,
> they are as copyrightable by the generator author as by the author or the
> .mhs file.

The DTS is a mechanical translation from one file format to another
(more or less).  Auto-inserting a copyright Xilinx (or anyone else) in
there would be unenforceable, and therefore should probably just go
away.

How would you feel if the FSF claimed copyright over object code
derived from your source files simply because you ran them through
gcc? :)  I believe there's a special clause in the GCC license to
explicitly cover this kind of situation.

Cheers,

John
