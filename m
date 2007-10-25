Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbXJYJ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbXJYJ3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbXJYJ3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:29:12 -0400
Received: from www.tglx.de ([62.245.132.106]:44027 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbXJYJ3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:29:11 -0400
Date: Thu, 25 Oct 2007 11:28:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] feature-removal-schedule: remove SA_* flags entry
In-Reply-To: <20071024162437.GM30533@stusta.de>
Message-ID: <alpine.LFD.0.9999.0710251128250.3186@localhost.localdomain>
References: <20071024162437.GM30533@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Oct 2007, Adrian Bunk wrote:

> No reason to keep the feature-removal-schedule.txt entry after the code
> was removed.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
> 
>  Documentation/feature-removal-schedule.txt |    9 ---------
>  1 file changed, 9 deletions(-)
> 
> ecf4ac4330ec61cecb1665c8c39702e600633b80 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 6b0f963..b9b8269 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -191,15 +191,6 @@ Who:	Nick Piggin <npiggin@suse.de>
>  
>  ---------------------------
>  
> -What:	Interrupt only SA_* flags
> -When:	September 2007
> -Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
> -	out of the signal namespace.
> -
> -Who:	Thomas Gleixner <tglx@linutronix.de>
> -
> ----------------------------
> -
>  What:	PHYSDEVPATH, PHYSDEVBUS, PHYSDEVDRIVER in the uevent environment
>  When:	October 2008
>  Why:	The stacking of class devices makes these values misleading and
> 
