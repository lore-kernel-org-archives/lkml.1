Return-Path: <linux-kernel-owner+w=401wt.eu-S1763519AbYBOJPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763519AbYBOJPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764966AbYBOJPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:15:03 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3377 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763631AbYBOJPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:15:00 -0500
Date: Fri, 15 Feb 2008 09:15:51 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: remove fastcall
Message-ID: <20080215091551.GC24479@shadowen.org>
References: <1203017488.2748.75.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203017488.2748.75.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 11:31:28AM -0800, Harvey Harrison wrote:
> fastcall no longer exists in tree, remove it from checkpatch.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Seems to be true :)  Have sucked this up for 0.15.  Thanks.

-apw

> ---
>  scripts/checkpatch.pl |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 2086a85..6f9b391 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -105,8 +105,7 @@ our $Sparse	= qr{
>  			__iomem|
>  			__must_check|
>  			__init_refok|
> -			__kprobes|
> -			fastcall
> +			__kprobes
>  		}x;
>  our $Attribute	= qr{
>  			const|
> -- 
> 1.5.4.1.1278.gc75be
> 
