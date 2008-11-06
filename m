Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYKFPmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYKFPmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYKFPmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:42:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:1140 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYKFPmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:42:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=bzCYdIAoBVdYuAu040ZnMqZ9/myCgIA/43GgTAQynyCQBYF+Gb5j/1evXYE6fO1lLF
         t94W+AVDsdFddb2cUlAMzJGPX5ySHVbbqkj6/7QSeLZYOpYj9mFiJPRHxWIJonwU7EpD
         CMpXm/myLH25dKsVFv7QJ5KJ5JaGDLWgoMk8E=
Message-ID: <cfd18e0f0811060742v46dd3f9eod624954cd9dcda3d@mail.gmail.com>
Date: Thu, 6 Nov 2008 10:42:03 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Marco Stornelli" <marco.stornelli@coritel.it>
Subject: Re: [PATCH] [RESEND] documentation: xip documentation update
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <49130E3C.5040203@coritel.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49130E3C.5040203@coritel.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco,

A few comments below.

On Thu, Nov 6, 2008 at 10:33 AM, Marco Stornelli
<marco.stornelli@coritel.it> wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
>
> xip documentation updated
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>
> --- a/Documentation/filesystems/xip.txt.orig    2008-08-20 20:11:37.000000000 +0200
> +++ b/Documentation/filesystems/xip.txt 2008-11-06 12:47:48.000000000 +0200
> @@ -39,10 +39,11 @@ The block device operation is optional,
>  today:
>  - dcssblk: s390 dcss block device driver
>
> -An address space operation named get_xip_page is used to retrieve reference
> -to a struct page. To address the target page, a reference to an address_space,
> -and a sector number is provided. A 3rd argument indicates whether the

> -function should allocate blocks if needed.
> +An address space operation named get_xip_mem is used to retrieve reference

s/reference/a reference/?

> +to a page frame number and a kernel address. To obtain these values a reference
> +to an address_space is provided. This function assigns values to the kmem and
> +pfn parameters. The 3rd argument indicates whether the function should allocate

It's a taste thing, but I would write "third" not "3rd".  (I
appreciate that the existing text already used "3rd", but maybe that
should be fixed.)

> +blocks if needed.
>
>  This address space operation is mutually exclusive with readpage&writepage that
>  do page cache read/write operations.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
