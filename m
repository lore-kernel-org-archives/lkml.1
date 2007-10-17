Return-Path: <linux-kernel-owner+w=401wt.eu-S1764866AbXJQKT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764866AbXJQKT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 06:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbXJQKTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 06:19:44 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:44979 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbXJQKTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 06:19:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=W569AOeHGhOi1CAes2ZJ//fozWGuC/hzItpyc+BHejkWGLCwCM8OseShHQPTN+NIaYCVxftd6SuZ4aO1tTdieFm5+VYcR2P0nD4/RcfHJrx+B10Yb45WKp+udGgHCNn5c52e+hSQet/ich8mc2j2S9uxQdkCsaaugaGjelPwTT4=
Subject: Re: [GIT PULL] Remove the use of magic macros for
	boot_params/screen_info
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Arch Mailing list <linux-arch@vger.kernel.org>
In-Reply-To: <200710170656.l9H6ugvf016636@tazenda.hos.anvin.org>
References: <200710170656.l9H6ugvf016636@tazenda.hos.anvin.org>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 18:19:16 +0800
Message-Id: <1192616356.31565.4.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-16 at 23:56 -0700, H. Peter Anvin wrote:
> Hi Linus,
> 
> Please pull:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git master
> 
> This patch removes all uses of magic macros to access the former
> zeropage, now the boot_params structure, as well as the screen_info
> structure.  The equivalent (pre-x86-merge) of the boot_params patch
> has been in -mm since shortly after 2.6.22.
> 
> A minor note: the video mode number 0x6A was officially assigned by
> VESA; the only VESA standard 7-bit video mode number ever assigned.
> 
> H. Peter Anvin (2):
>       [x86] remove uses of magic macros for boot_params access
>       Remove magic macros for screen_info structure members
> 

>  drivers/video/console/dummycon.c   |    4 +-
>  drivers/video/console/vgacon.c     |   51 ++++++++++++++-------------
>  drivers/video/intelfb/intelfbdrv.c |    5 ++-
>  drivers/video/vga16fb.c            |    2 +-

Acked-by: Antonino A. Daplas <adaplas@gmail.com>

with respect to the drivers/video portion.

Tony

