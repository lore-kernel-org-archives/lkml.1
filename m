Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbXFURQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbXFURQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbXFURQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:16:14 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:53689 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992AbXFURQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:16:13 -0400
Date: Thu, 21 Jun 2007 13:16:12 -0400
To: Michael Poole <mdpoole@troilus.org>
Cc: david@lang.hm, "H. Peter Anvin" <hpa@zytor.com>,
       Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070621171612.GC10008@csclub.uwaterloo.ca>
References: <9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com> <2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com> <871wg6trnx.fsf@graviton.dyn.troilus.org> <467977F7.2040506@zytor.com> <Pine.LNX.4.64.0706201200550.30395@asgard.lang.hm> <87sl8ms9z5.fsf@graviton.dyn.troilus.org> <Pine.LNX.4.64.0706201234230.30395@asgard.lang.hm> <87k5tys8w5.fsf@graviton.dyn.troilus.org> <Pine.LNX.4.64.0706201253120.30395@asgard.lang.hm> <87645is82q.fsf@graviton.dyn.troilus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87645is82q.fsf@graviton.dyn.troilus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 04:07:57PM -0400, Michael Poole wrote:
> I do not say that the BIOS is doing anything (legally) wrong.  The
> wrong act is distributing the binary kernel image without distributing
> complete source code for it.

So how about this idea then:

Tivo builds a kernel for their box, and release all the sources for how
to build exactly that kernel.

Tivo builds a bios image for their box, and encodes into it the checksum
of the kernel, or at least parts of it that they want to ensure are
present and unmodified.

Everytime the device boots, it checks the kernel image, and it the
checksums match, it loads and runs the kernel, and otherwise it checks
if there is a new bios image with a proper signature, updates itself and
reboots and tries again.

Preventing people from doing things with their own hardware certainly
seems morally wrong, but legally, I don't see any way to prevent it.

I suppose you could say in the license: You may not use this code in any
way if you do what the RIPP/MPAA/etc want you to do.

--
Len Sorensen
