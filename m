Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYIHWjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYIHWjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYIHWjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:39:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33814 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYIHWjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:39:15 -0400
Message-ID: <48C5A95D.8050108@zytor.com>
Date: Mon, 08 Sep 2008 15:38:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, w@1wt.eu
Subject: Re: [update] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809082233.m88MXMhZ027949@hitchhiker.org.lu>
In-Reply-To: <200809082233.m88MXMhZ027949@hitchhiker.org.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
>  
>  	/* Replace the compressed data size with the uncompressed size */
>  	subl input_len(%ebp), %ebx
> +#ifdef CONFIG_KERNEL_LZMA
> +	movl output_len_lzma(%ebp), %eax
> +#else
>  	movl output_len(%ebp), %eax
> +#endif
>  	addl %eax, %ebx

These particular #ifdefs really have to go, one way or another.

	-hpa
