Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbYJSXZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbYJSXZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 19:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYJSXZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 19:25:25 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38723 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbYJSXZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 19:25:24 -0400
Date: Mon, 20 Oct 2008 00:25:22 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andres Freund <andres@anarazel.de>
cc: linux-kernel@vger.kernel.org, keithp@keithp.com
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
In-Reply-To: <200810200111.06461.andres@anarazel.de>
Message-ID: <alpine.DEB.0.82.0810200022500.27788@skynet.skynet.ie>
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie>
 <200810200111.06461.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> On Thursday 16 October 2008 08:59:57 Dave Airlie wrote:
> > Please pull the 'agp-next' branch from
> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git
> > agp-next
> >
> > This just contains some suspend/resume fixes for the SiS, Intel memory
> > sizing fix for new hw, and support for more memory types on the nvidia
> > AGP.
> One of those patches breaks X on my laptop with:
> 
> (II) intel(0): xf86BindGARTMemory: bind key 0 at 0x01f7f000 (pgoffset 8063)
> (WW) intel(0): xf86BindGARTMemory: binding of gart memory with key 0
>     at offset 0x1f7f000 failed (Invalid argument)
> 
> Fatal server error:
> Couldn't bind memory for exa offscreen
> 
> (Found via bisect with some guessing)
> 
> If neccessary I can bisect further, but I guess you know what the problem is.
> 
> Andres
> 
> 
> Xorg is: 1.5.2-2
> Xorg Intel: 2.4.1-1ubuntu9
> 

What type of laptop is it and what GPU has it.
if distros are carrying GM45 supporting stuff we might be in trouble..

Dave.
