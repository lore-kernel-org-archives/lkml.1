Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722Ab0AXX00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab0AXX00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514Ab0AXX00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:26:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56617 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab0AXX0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:26:25 -0500
Message-ID: <4B5CD711.7050204@zytor.com>
Date: Sun, 24 Jan 2010 15:26:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Nigel Kukard <nkukard@lbsd.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel 2.6.33-rc4 OOPS's with large initramfs
References: <4B519F14.7020104@lbsd.net>
In-Reply-To: <4B519F14.7020104@lbsd.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2010 03:12 AM, Nigel Kukard wrote:
> 
> Generating a initramfs with the following, one of about 30Mb, one of 77Mb.
> find . | cpio -o -H newc > ../initramfs.cpio
> 
> Only difference is adding of more files to the 77Mb image.
> 
> It makes no difference if its compiled into kernel or used as initrd.
> Compression types makes no difference either.
> 
> Tested on 2.6.32.3->2.6.33-rc4 , all fail with the below.
> 
> The 30Mb initramfs loads fine, the 77Mb image throws the following...
> 

What are the exact compressed and uncompressed files (or is that an
uncompressed initramfs)?

Also, you're describing how to reproduce this with Qemu, but have you
tried with other bootloaders?  Which version of Qemu (some versions of
the Qemu bootloaders had a lot of problems.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

