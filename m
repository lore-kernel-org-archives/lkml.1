Return-Path: <linux-kernel-owner+w=401wt.eu-S1765762AbYBMHPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765762AbYBMHPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbYBMHO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:14:58 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:39497 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbYBMHO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:14:57 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] wmi: (!x & y) strikes again
Date: Wed, 13 Feb 2008 07:14:50 +0000
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20080213040325.GS27894@ZenIV.linux.org.uk>
In-Reply-To: <20080213040325.GS27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802130714.50961.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Wed, 13 Feb 2008 07:15:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 04:03:25 Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

> ---
> d2d6f5b9eb315a53043a722d952bb21ed5ca1229
> diff --git a/drivers/acpi/wmi.c b/drivers/acpi/wmi.c
> index 457ed3d..efacc9f 100644
> --- a/drivers/acpi/wmi.c
> +++ b/drivers/acpi/wmi.c
> @@ -247,7 +247,7 @@ u32 method_id, const struct acpi_buffer *in, struct acpi_buffer *out)
>  	block = &wblock->gblock;
>  	handle = wblock->handle;
>  
> -	if (!block->flags & ACPI_WMI_METHOD)
> +	if (!(block->flags & ACPI_WMI_METHOD))
>  		return AE_BAD_DATA;
>  
>  	if (block->instance_count < instance)
> 
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
