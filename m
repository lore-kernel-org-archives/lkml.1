Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbYG2WG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbYG2WG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYG2WGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:06:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbYG2WGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:06:50 -0400
Date: Tue, 29 Jul 2008 15:03:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.27-rc1
In-Reply-To: <20080729215942.GA22760@uranus.ravnborg.org>
Message-ID: <alpine.LFD.1.10.0807291502271.3334@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <20080729213746.GA22548@uranus.ravnborg.org> <alpine.LFD.1.10.0807291439270.3334@nehalem.linux-foundation.org> <20080729215942.GA22760@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Jul 2008, Sam Ravnborg wrote:
> 
> For arm the actual diff is:
>  Makefile                 |   20 +++++++-------------
>  boot/compressed/Makefile |    3 ---
>  tools/Makefile           |    1 +
>  3 files changed, 8 insertions(+), 16 deletions(-)
> 
> But on top of this there are ~600 files that needed a
> replacement of:
> #include <asm/arch/foo.h>
> to
> #include <arch/foo.h>

Yeah, that latter part doesn't strike me as wonderful.

> So maybe not such a minimal patch - because I wanted to drop all
> the symlink stuff.

Why? There's nothing wrong with symlinks.

The problem with 'include/asm' isn't the symlink per se, it's that it 
split up the architecture parts in two separate areas - arch and include.

			Linus
