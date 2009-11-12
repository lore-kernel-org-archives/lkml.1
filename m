Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZKLWnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZKLWnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZKLWnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:43:37 -0500
Received: from mail.free-electrons.com ([88.191.76.200]:41148 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbZKLWnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:43:37 -0500
Date: Thu, 12 Nov 2009 23:43:36 +0100
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hpa@zytor.com, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] Add support for LZO-compressed kernels
Message-ID: <20091112224319.GJ2605@pc-ran3241.res.insa>
References: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com>
 <20091112143323.6b80ca4e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112143323.6b80ca4e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 14:33 -0800, Andrew Morton wrote :
> On Wed, 11 Nov 2009 13:27:55 +0100
> Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:
> 
> > +STATIC inline int INIT unlzo(u8 *input, int in_len,
> 
> I assume the macro gunk is to support testing of the code in a
> userspace test haress?

> Where does INIT get defined?

STATIC and INIT are both defined in include/linux/decompress/mm.h. They're
needed to support using the decompression code both in the kernel bootstrap code
if the kernel image is compressed, and as part of the kernel code if it used to
extract an initrd/initramfs image.

Regards,
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
