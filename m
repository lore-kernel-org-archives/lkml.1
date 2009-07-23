Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZGWWKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZGWWKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 18:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZGWWKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 18:10:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43010 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbZGWWKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 18:10:21 -0400
Message-ID: <4A68DFC4.5070809@zytor.com>
Date: Thu, 23 Jul 2009 15:10:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Subodh Nijsure <nijsure.subodh@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Way to combine kernel and initrd on x86 platform?
References: <110c8b2e0907221415q77f7416ehcff4ad26d834bce2@mail.gmail.com>	 <4A67CD97.8000609@zytor.com> <110c8b2e0907231350v122543a0n9a3aabc3aee59623@mail.gmail.com>
In-Reply-To: <110c8b2e0907231350v122543a0n9a3aabc3aee59623@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subodh Nijsure wrote:
> 
> Sorry if I am not being very smart  here, confused by the remark "
> bzImage support would not be possible"
> 
> I was able create wrapped image using command
> 
> wraplinux -p "console=ttyS0,115200" -i initrd.gz -o
> vmlinux.initrd.wrap arch/i386/boot/bzImage
> 
> I am using wraplinux version 1.6
> 
> if I use any other image  wraplinux doesn't find the version
> information and initrd image doesn't get attached.
> 
> What file should I be specifying as the 'kernel' when I execute
> wrapimage  if not the bzImage?
> 
> ( I am working with 2.6.23 kernel)
> 
> On my board I can boot the standard bzImage, but not able to load the
> wrapped image produced by wraplinux command. Would very much
> appreciate hints...
> 

What I mean is that Wraplinux accepts bzImage as input and outputs ELF,
NBI or Multiboot.  Depending on the bootloader on your board, you may
need to select one or the other of these formats, or might not be able
to at all.  It does not *output* bzImage, and it isn't 100% trivial to
make it do so.

	-hpa

