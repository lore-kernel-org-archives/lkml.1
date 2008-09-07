Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYIGS2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYIGS2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 14:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYIGS1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 14:27:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:43431 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbYIGS13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 14:27:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=n6ZW2uKNR88BCII9XX/m0vWrRbVkJg+3/jB5ARsfvfziwCFwEDNSjbOaETYE6tcjPo
         8m3+5Ubz2jN83dGv1DDZ7uh+R6rcXHI3VCdYN03I758C4swz0Di1PbL/JkBFGl15d54G
         MSVDPeBD1r4Z/XtWY7bdTWzEM2RS6DTviM04Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 2/2] ide-cd: add a debug_mask module parameter
Date: Sun, 7 Sep 2008 20:21:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1219496923-20868-1-git-send-email-petkovbb@gmail.com> <1219496923-20868-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1219496923-20868-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809072021.25277.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 August 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied

> ---
>  drivers/ide/ide-cd.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index cca1011..5e0b9cd 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -53,6 +53,8 @@
>  
>  #include "ide-cd.h"
>  
> +static unsigned long debug_mask = 0x0;

No need to zero it, I fixed it and moved debug_mask next to module_param().
