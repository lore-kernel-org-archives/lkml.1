Return-Path: <linux-kernel-owner+w=401wt.eu-S1030862AbXCNODL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030862AbXCNODL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030865AbXCNODL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:03:11 -0400
Received: from csclub1.cs.uwaterloo.ca ([129.97.7.226]:60158 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030862AbXCNODK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:03:10 -0400
Date: Wed, 14 Mar 2007 10:03:09 -0400
To: Faik Uygur <faik@pardus.org.tr>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel-parameters.txt: ATAPI enabled by default
Message-ID: <20070314140309.GH22466@csclub.uwaterloo.ca>
References: <200703141107.41168.faik@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703141107.41168.faik@pardus.org.tr>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 11:07:40AM +0200, Faik Uygur wrote:
> In case of libata, discovery of ATAPI devices is the default behaviour.
> 
> Signed-off-by: Faik Uygur <faik@pardus.org.tr>
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 856c8b1..96b6ec5 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -695,11 +695,9 @@ and is between 256 and 4096 characters. It is defined in the file
>  			Format: <irq>
>  
>  	combined_mode=	[HW] control which driver uses IDE ports in combined
> -			mode: legacy IDE driver, libata, or both
> -			(in the libata case, libata.atapi_enabled=1 may be
> -			useful as well).  Note that using the ide or libata
> -			options may affect your device naming (e.g. by
> -			changing hdc to sdb).
> +			mode: legacy IDE driver, libata, or both. Note that
> +			using the ide or libata options may affect your device
> +			naming (e.g. by changing hdc to sdb).
>  			Format: combined (default), ide, or libata

I am having trouble parsing this one. 

Does combined_mode=combined mean both?

What does using both legacy and libata at the same time mean?

Who runs the PATA ports?

Please don't use the term IDE ports, since I have no idea what that
means anymore.

This message is really not very helpful right now.

--
Len Sorensen
