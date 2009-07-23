Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZGWCk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZGWCk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 22:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZGWCkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 22:40:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47751 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZGWCkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 22:40:25 -0400
Message-ID: <4A67CD97.8000609@zytor.com>
Date: Wed, 22 Jul 2009 19:40:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.1) Gecko/20090715 Thunderbird/3.0b3
MIME-Version: 1.0
To: Subodh Nijsure <nijsure.subodh@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Way to combine kernel and initrd on x86 platform?
References: <110c8b2e0907221415q77f7416ehcff4ad26d834bce2@mail.gmail.com>
In-Reply-To: <110c8b2e0907221415q77f7416ehcff4ad26d834bce2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2009 02:15 PM, Subodh Nijsure wrote:
> I have been using the arch/powerpc/boot/wrapper scripts to combine
> linux and initrd.gz to create a single image for distribution.
> 
> Is there similar wrapper possible for x86 platforms also? This is my
> first week of working on x86 embedded platform.
> 
> I know of initramfs option in 2.6 kernel, however the contents of
> initrd in my case are created after the kernel is build i.e. will have
> to "patch in" the initramfs at later point in build process.

If your bootloader can support ELF, Multiboot, or NBI, you can use
Wraplinux:

	http://www.kernel.org/pub/linux/utils/boot/wraplinux/

bzImage support would be possible, but it isn't in this version (noone
has asked for it).

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

