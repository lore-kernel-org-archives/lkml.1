Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYIFW3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYIFW3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 18:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYIFW3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 18:29:15 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:2813 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYIFW3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 18:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j+x0UWHioz/w/B9VU6wJg113rF3cFrMigfvplKoCfOKcfnpTcrxOqkMvbTYKLS9nXI
         EIi8Z7lOSFKcgCFTyQwn3U9qXeQnGTdXirTdRKJygbJ6fF38sG9+VhejQjfbbqMwpVSy
         T5ewSTolKYE7xel5YfItNTSOJgUzxjkfRI62Q=
Message-ID: <c384c5ea0809061529g2c7280d8j216f7791ceeb439a@mail.gmail.com>
Date: Sun, 7 Sep 2008 00:29:13 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Alain Knaff" <alain@knaff.lu>
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

a small remark on the non-code parts:

On Sat, Sep 6, 2008 at 11:19 PM, Alain Knaff <alain@knaff.lu> wrote:
>
> compressing the kernel with bzip2 or lzma rather than gzip. Both
> compressors give smaller sizes than gzip.  Moreover, lzma's
> decompresses faster than gzip.
>
versus

> +config KERNEL_GZIP
> +       bool "Gzip"
> +       help
> +         The old and tried gzip compression. Its compression ratio is
> +        the poorest among the 3 choices; however its speed (both
> +        compression and decompression) is the fastest.
> +

This seems contradictionary information.

However, I welcome more compression options in kernel and filesystem
land, so I'm very interested in this patch.
Recently, on the filesystem side there seems to be some effort to
modularize the decompressors, instead of the use of #ifdef's.

The other architectures (especially used in embedded) need to hook in
on this, getting rid of the many out-of-tree patches for kernel/fs
decompression.

Regards,
-- 
Leon
