Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXIVWHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXIVWHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 18:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXIVWHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 18:07:34 -0400
Received: from barikada.upol.cz ([158.194.242.200]:39102 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbXIVWHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 18:07:33 -0400
Date: Sun, 23 Sep 2007 00:23:11 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unfortunate infinite make recursion
Message-ID: <20070922222311.GQ24301@flower.upol.cz>
References: <Pine.LNX.4.64.0709221319440.15712@fbirervta.pbzchgretzou.qr> <E1IZ788-0003LZ-Qs@flower> <20070922204002.GA31873@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922204002.GA31873@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 10:40:02PM +0200, Sam Ravnborg wrote:
> On Sat, Sep 22, 2007 at 05:42:52PM +0200, Oleg Verych wrote:
> > * Sat, 22 Sep 2007 13:24:32 +0200 (CEST)
> > []
> > > The make O=$PWD truncates the Makefile, making it necessary to run `git 
> > > checkout Makefile` - should you have git; or reextract the tarball 
> > > (should you /still/ have it). Well, can we catch this case somehow?
> > 
> > Read-only source-tree for kbuild user, end of question. By current kbuild
> > one can garbage source by various means. Read-write for quilt, git and
> > editor users.
> 
> Please Oleg.
> You know very well that most people will not have their kernel src RO.

Sure, if it will be not comfortable.

But if kbuild deals with this transparently, it must be OK. Brokenness
due to binutils, kbuild, root user bugs won't garbage source. Only thing
to ask from experienced users *and* kernel developers, is
`useradd kbuild`, everything else will not bother anybody.

I just express my vision, of course. But see, i can't play with kernel
sources error-free now. If i type some `make` somewhere in obj or src
tree, i need to know, that vanilla source stays so in any circumstances.
Currently it's not.

It is about making things in order on my working place (not looking to be
in order, though :). Not thinking every time, if something fscked sources,
saves my and time of diff/patch. Experimenting/testing/finding fixes with
small amount of in-development sources in obj tree, also very helpful.
____
