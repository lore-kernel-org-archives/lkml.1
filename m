Return-Path: <linux-kernel-owner+w=401wt.eu-S1762023AbYG3NDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762023AbYG3NDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 09:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758906AbYG3ND0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 09:03:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431AbYG3NDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:03:25 -0400
Date: Wed, 30 Jul 2008 09:03:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [patch] kdump: update elfcorehdr documentation to reflect
	supported architectures
Message-ID: <20080730130321.GC16373@redhat.com>
References: <20080730003026.GA22106@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730003026.GA22106@verge.net.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 10:30:28AM +1000, Simon Horman wrote:
> IA64, PPC and SH also support the elfcorehdr command line.
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Index: linux-2.6/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/kernel-parameters.txt	2008-07-30 09:48:40.000000000 +1000
> +++ linux-2.6/Documentation/kernel-parameters.txt	2008-07-30 09:48:45.000000000 +1000
> @@ -688,7 +688,7 @@ and is between 256 and 4096 characters. 
>  			See Documentation/block/as-iosched.txt and
>  			Documentation/block/deadline-iosched.txt for details.
>  
> -	elfcorehdr=	[X86-32, X86_64]
> +	elfcorehdr=	[IA64,PPC,SH,X86-32,X86_64]
>  			Specifies physical address of start of kernel core
>  			image elf header. Generally kexec loader will
>  			pass this option to capture kernel.

Thanks Simon.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

