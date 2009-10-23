Return-Path: <linux-kernel-owner+w=401wt.eu-S1751680AbZJWKJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbZJWKJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 06:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZJWKJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 06:09:04 -0400
Received: from fifo99.com ([67.223.236.141]:39570 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZJWKJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 06:09:03 -0400
Subject: Re: [PATCH] dmi_check_system can generate Warnings when no DMI
 table is present
From: Daniel Walker <dwalker@fifo99.com>
To: Erwan Velu <erwanaliasr1@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <4AE178AF.3010804@gmail.com>
References: <4AE178AF.3010804@gmail.com>
Content-Type: text/plain
Date: Fri, 23 Oct 2009 03:08:57 -0700
Message-Id: <1256292537.10493.48.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 11:34 +0200, Erwan Velu wrote:
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index 938100f..ea8b433 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -457,6 +457,9 @@ int dmi_check_system(const struct dmi_system_id
> *list)
>      int count = 0;
>      const struct dmi_system_id *d;
>  
> +    if (!dmi_available)
> +        return 0;
> +
>      for (d = list; d->ident; d++)
>          if (dmi_matches(d)) {
>              count++;

It looks like all the tabs have been removed from the code. Did you copy
and paste the patch content into this email? Often times that will
remove the tabs.

Daniel

