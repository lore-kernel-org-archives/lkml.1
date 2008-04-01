Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbYDASBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbYDASBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 14:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbYDASBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 14:01:31 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48404 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757103AbYDASBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 14:01:31 -0400
Date: Tue, 1 Apr 2008 20:01:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, trivial@kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] powerpc: replace `__attribute' by `__attribute__'
Message-ID: <20080401180156.GA14553@uranus.ravnborg.org>
References: <47F26FF6.8070300@tiscali.nl> <47F27155.1000103@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F27155.1000103@tiscali.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 07:31:01PM +0200, Roel Kluin wrote:
> replace `__attribute' by `__attribute__'
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/arch/powerpc/platforms/iseries/main_store.h b/arch/powerpc/platforms/iseries/main_store.h
> index 1a7a3f5..976b23e 100644
> --- a/arch/powerpc/platforms/iseries/main_store.h
> +++ b/arch/powerpc/platforms/iseries/main_store.h
> @@ -61,7 +61,7 @@ struct IoHriMainStoreSegment4 {
>  };
>  
>  /* Main Store VPD for Power4 */
> -struct __attribute((packed)) IoHriMainStoreChipInfo1 {
> +struct __attribute__((packed)) IoHriMainStoreChipInfo1 {
>  	u32	chipMfgID;
>  	char	chipECLevel[4];
>  };

Please introduce __packed if you touch this.
See include/linux/compiler-gcc.h

This comment is relevant for all your patches.
We have __used and other similar variants.

So take a good look at include/linux/compiler* and
use the proper shortcuts where available.

	Sam
