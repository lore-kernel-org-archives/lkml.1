Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbXEXUWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbXEXUWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbXEXUWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:22:41 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:46817 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbXEXUWk (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s7ZNVAmTkGYwmzDkoSRgGv1M124MnpV+YheoB9zSswbSz5pw1xnJvgsj+uBhaXLdNBtAs/NrItiSPdRnrPRgVR5mbB9PEIvhZKgWgRRSnz+gaMDt6mj3hGwjwWvB2G5yp8TSwEKh3lMu42pmb5/qG84rf5vG0GMjhbOeR20AYH8=
Message-ID: <6934efce0705241322j7ad7c4fex621217e0749ddf3e@mail.gmail.com>
Date: Thu, 24 May 2007 13:22:37 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: richard.griffiths@windriver.com
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Cc: Linux-kernel@vger.kernel.org
In-Reply-To: <1179871779.24163.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Richard Griffiths <res07ml0@verizon.net> wrote:
> Venerable cramfs fs Linear XIP patch originally from MontaVista, used in
> the embedded Linux community for years, updated for 2.6.21. Tested on
> several systems with NOR Flash. PXA270, TI OMAP2430, ARM Versatile and
> Freescale iMX31ADS.
>

When trying to verify this patch on our PXA270 system we get the
following error when running an XIP rootfs:

cramfs: checking physical address 0xa00000 for linear cramfs image
cramfs: linear cramfs image appears to be 3236 KB in size
VFS: Mounted root (cramfs filesystem) readonly.
Freeing init memory: 96K
/sbin/init: error while loading shared libraries: libgcc_s.so.1:
failed to map segment from shared object: Error 11
Kernel panic - not syncing: Attempted to kill init!

However, if our busybox binary is XIP while the libgcc_s.so.1 is not
XIP, busybox runs fine.

Richard, May I email you the rootfs tarball so you can recreate what
we are seeing?  It is a little less than 2MiB.  The filing system
executables will only run on a PXA27x processor.
