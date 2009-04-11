Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZDKDpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZDKDpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 23:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbZDKDpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 23:45:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993AbZDKDpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 23:45:00 -0400
Date: Fri, 10 Apr 2009 20:43:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dag Bakke <dag@bakke.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: video (VGA) object-files unconditionally built/included?
Message-Id: <20090410204308.155b7d65.akpm@linux-foundation.org>
In-Reply-To: <49DF2DCE.5050102@bakke.com>
References: <49DF2DCE.5050102@bakke.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 13:30:22 +0200 Dag Bakke <dag@bakke.com> wrote:

> Hi.
> 
> I am putting together a tiny kernel for an embedded x86 target. Space is
> tight, so I try to shave every kB I can get rid of.
> I don't have anything resembling VGA or graphics, and my .config
> reflects that. (Serial console.)
> 
> Yet, when building the kernel I see:
> 
>   LZMA    arch/x86/boot/compressed/vmlinux.bin.lzma
>   CC      arch/x86/boot/video.o
>   CC      arch/x86/boot/video-mode.o
>   CC      arch/x86/boot/version.o
>   CC      arch/x86/boot/video-vga.o
>   CC      arch/x86/boot/video-vesa.o
>   CC      arch/x86/boot/video-bios.o
> 
> # strings arch/x86/boot/bzImage | egrep -i 'vesa|vga|bios|mode'
> +VESA
> 0123456789ABCDEFPress <ENTER> to see video modes available, <SPACE> to
> continue, or wait 30 sec
> Mode: Resolution:  Type:
> Enter a video mode or "scan" to scan for additional modes:
> Undefined video mode number: %x
> VESA
> BIOS
> 
> 
> The video* objects sums up to 87kB. Can I get rid of that somehow? I am
> using current git.
> 
> This is my .config:
> http://tapas.homeip.net/~dagb/tiny.config
> 

I don't think those video things end up consuming memory after the
kernel has booted?

