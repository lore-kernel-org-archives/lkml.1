Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbXFUR0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbXFUR0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbXFURZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:25:51 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:38457
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbXFURZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:25:50 -0400
Date: Thu, 21 Jun 2007 10:26:04 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Michael Poole <mdpoole@troilus.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070621171612.GC10008@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0706211019510.31603@asgard.lang.hm>
References: <9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>
 <2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com>
 <871wg6trnx.fsf@graviton.dyn.troilus.org> <467977F7.2040506@zytor.com>
 <Pine.LNX.4.64.0706201200550.30395@asgard.lang.hm> <87sl8ms9z5.fsf@graviton.dyn.troilus.org>
 <Pine.LNX.4.64.0706201234230.30395@asgard.lang.hm> <87k5tys8w5.fsf@graviton.dyn.troilus.org>
 <Pine.LNX.4.64.0706201253120.30395@asgard.lang.hm> <87645is82q.fsf@graviton.dyn.troilus.org>
 <20070621171612.GC10008@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Lennart Sorensen wrote:

> 
> On Wed, Jun 20, 2007 at 04:07:57PM -0400, Michael Poole wrote:
>> I do not say that the BIOS is doing anything (legally) wrong.  The
>> wrong act is distributing the binary kernel image without distributing
>> complete source code for it.
>
> So how about this idea then:
>
> Tivo builds a kernel for their box, and release all the sources for how
> to build exactly that kernel.
>
> Tivo builds a bios image for their box, and encodes into it the checksum
> of the kernel, or at least parts of it that they want to ensure are
> present and unmodified.
>
> Everytime the device boots, it checks the kernel image, and it the
> checksums match, it loads and runs the kernel, and otherwise it checks
> if there is a new bios image with a proper signature, updates itself and
> reboots and tries again.

the bios doesn't have enough capability to talk to the outside world for 
updates.

what tivo actually does is very similar to this

they encode into the bios the ability to check a checksum/signature for 
the kernel+boot filesystem and if they don't match look to see if there is 
another kernel+boot filesystem available

then software on the boot filesystem checks to see if the rest of the 
system has been tampered with before it mounts /

> Preventing people from doing things with their own hardware certainly
> seems morally wrong, but legally, I don't see any way to prevent it.
>
> I suppose you could say in the license: You may not use this code in any
> way if you do what the RIPP/MPAA/etc want you to do.

the GPLv3 is trying to do this.

David Lang
