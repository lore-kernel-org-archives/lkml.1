Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbYFSJ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbYFSJ6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbYFSJ6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:58:11 -0400
Received: from ping.pong.ch ([212.103.71.101]:54519 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbYFSJ6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:58:10 -0400
Date: Thu, 19 Jun 2008 11:58:05 +0200
From: Gaudenz Steinlin <gaudenz@debian.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, 486798@bugs.debian.org, josejx@gentoo.org
Subject: Re: [PATCH] restore export of handle_mm_fault for Mac on Linux
Message-ID: <20080619095805.GA28907@soziologie.ch>
References: <20080618101402.GF15718@soziologie.ch> <20080618181856.3474859d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618181856.3474859d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 06:18:56PM +0100, Alan Cox wrote:
> On Wed, 18 Jun 2008 12:14:02 +0200
> Gaudenz Steinlin <gaudenz@debian.org> wrote:
> 
> > Hi
> > 
> > The kernel modules for Mac on Linux (MOL) need handle_mm_fault. 
> > MOL is a GPL licensed virtual machine to run MacOS(X) on PPC Linux.
> > 
> > The export for handle_mm_fault was removed with commit
> > 41f9dc5c871600f53c8912b2975971d2a11c1c25. 
> 
> This sort of thing is going to happen if modules hide out of tree. If MOL
> is GPL why isn't it getting submitted to the kernel tree - other
> virtualisation subsystems such as KVM are in tree ?

There is an effort underway to bring the MOL kernel modules into
a mergeable form. But it's not there yet. Joseph Jezak, the MOl main
developer nowdays is working on it. So MOL no longer want's to hide out
of tree. It just needs some more time.

What I'm asking for is to get the export back, that as far as I can see
was removed accidentialy and that was there before specially for MOL. 

It's true that this has been requested before just after the symbol was
removed and Christoph NAKed it then. But if I remember correctly people
were not aware that this symbol has been exported specifically for MOL
before back then.

Gaudenz

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
