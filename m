Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYFTTDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYFTTDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYFTTDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:03:43 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:54660 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbYFTTDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:03:42 -0400
Date: Fri, 20 Jun 2008 15:03:40 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: fix mutex names
In-reply-to: <20080620115656.GA17426@damson.getinternet.no>
X-X-Sender: lenb@localhost.localdomain
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <alpine.LFD.1.10.0806201503170.3027@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080620115656.GA17426@damson.getinternet.no>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


looks good.
CONFIG_ACPI_DEBUG=y thanks you.

-Len


On Fri, 20 Jun 2008, Vegard Nossum wrote:

> Hi,
> 
> I came across this as I was looking at Ingo's report. This looks correct,
> yeah? (The alternative is to switch the #defines around, but that has
> more serious implications than changing just what is displayed on the
> screen!)
> 
> 
> Vegard
> 
> 
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Fri, 20 Jun 2008 13:49:22 +0200
> Subject: [PATCH] ACPI: fix mutex names
> 
> This patch reorders the mutex names to match the preceding #defines
> and comment:
> 
>     /*
>      * NOTE: any changes here must be reflected in the acpi_gbl_mutex_names
>      * table below also!
>      */
>     #define ACPI_MTX_INTERPRETER            0       /* AML Interpreter, main lock */
>     #define ACPI_MTX_NAMESPACE              1       /* ACPI Namespace */
>     #define ACPI_MTX_TABLES                 2       /* Data for ACPI tables */
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  include/acpi/aclocal.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/acpi/aclocal.h b/include/acpi/aclocal.h
> index c5cdc32..62d7468 100644
> --- a/include/acpi/aclocal.h
> +++ b/include/acpi/aclocal.h
> @@ -98,8 +98,8 @@ union acpi_parse_object;
>  
>  static char *acpi_gbl_mutex_names[ACPI_NUM_MUTEX] = {
>  	"ACPI_MTX_Interpreter",
> -	"ACPI_MTX_Tables",
>  	"ACPI_MTX_Namespace",
> +	"ACPI_MTX_Tables",
>  	"ACPI_MTX_Events",
>  	"ACPI_MTX_Caches",
>  	"ACPI_MTX_Memory",
> -- 
> 1.5.4.1
> 
