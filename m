Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbXJVIGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbXJVIGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 04:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXJVIGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 04:06:14 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:56227 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbXJVIGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 04:06:13 -0400
Date: Mon, 22 Oct 2007 03:01:31 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: WANG Cong <xiyou.wangcong@gmail.com>
cc: Nix <nix@esperi.org.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Jeff Dike <jdike@addtoit.com>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
In-Reply-To: <20071022065202.GI2998@hacking>
Message-ID: <Pine.LNX.4.64.0710220300180.701@localhost.localdomain>
References: <200710200252.37919.p.giarrusso@gmail.com> <87y7dyhv2u.fsf@hades.wkstn.nix>
 <20071021114854.GF2455@hacking> <20071021130848.GA4621@c2.user-mode-linux.org>
 <20071021132031.GI2455@hacking> <20071021154346.GW8181@ftp.linux.org.uk>
 <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk>
 <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix>
 <20071022065202.GI2998@hacking>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, WANG Cong wrote:

> On Mon, Oct 22, 2007 at 07:42:33AM +0100, Nix wrote:
> >On 22 Oct 2007, WANG Cong uttered the following:
> >> I build UML for non-SMP x86. But I don't know about UML_NET_VDE. ;(
> >>
> >> Errors threw out by gcc (too many) are put here:
> >> 	http://wangcong.org/down/errors.txt
> >
> >It's hard to tell without LOCALE=C, but those are the sorts of results
> >I'd expect if you had run make {old,menu,x}config without specifying
> >ARCH=um, so you've configured for one architecture and are now trying
> >to build another.
> >
> >Where is the include/asm symlink pointing to in your build tree?
>
> $ ls -l include/asm
> lrwxrwxrwx 1 wangcong wangcong 6 2007-10-22 12:34 include/asm -> asm-um
>
> OK. Let me do the following:
>
> 	$ make mrproper

...

if you wanted to be *really* anal retentive, you might want to run
"make distclean" instead but, from what i've seen so far, i don't
think that would change what you're seeing.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
