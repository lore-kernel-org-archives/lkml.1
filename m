Return-Path: <linux-kernel-owner+w=401wt.eu-S1161522AbXBHEcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161522AbXBHEcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 23:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161518AbXBHEcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 23:32:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54558 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161517AbXBHEcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 23:32:23 -0500
Date: Wed, 7 Feb 2007 20:32:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sk98lin: planned removal
Message-Id: <20070207203215.bdf3908b.akpm@linux-foundation.org>
In-Reply-To: <20070207091830.59f72f46@oldman>
References: <20070207091830.59f72f46@oldman>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 09:18:30 -0800 Stephen Hemminger <shemminger@linux-foundation.org> wrote:

> Document planned removal of sk98lin driver.
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
> ---
>  Documentation/feature-removal-schedule.txt |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 0ba6af0..d08a4af 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -325,3 +325,10 @@ Why:	Unmaintained for years, superceded 
>  Who:	Jeff Garzik <jeff@garzik.org>
>  
>  ---------------------------
> +
> +What:   sk98lin network driver
> +When:   July 2007
> +Why:    In kernel tree version of driver is unmaintained. Sk98lin driver
> +	replaced by the skge driver. 
> +Who:    Stephen Hemminger <shemminger@osdl.org>
> +

People don't read that file.  I'd suggest the addition of a warning printk
to the driver's open() method.
