Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbZETH45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbZETH45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZETH4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:56:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57030 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZETH4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:56:49 -0400
To: Karsten Keil <keil@b1-systems.de>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH 01/19] Add XHFC support for embedded Speech-Design board to hfcmulti
From: Andi Kleen <andi@firstfloor.org>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
	<81986b3e8ddbb4501dce5add2707d5dcec449a23.1242739648.git.kkeil@pingi.linux-pingi.de>
Date: Wed, 20 May 2009 09:56:44 +0200
In-Reply-To: <81986b3e8ddbb4501dce5add2707d5dcec449a23.1242739648.git.kkeil@pingi.linux-pingi.de> (Karsten Keil's message of "Tue, 19 May 2009 15:58:22 +0200")
Message-ID: <87y6ssnr5v.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Keil <keil@b1-systems.de> writes:


> --- a/drivers/isdn/hardware/mISDN/hfc_multi.h
> +++ b/drivers/isdn/hardware/mISDN/hfc_multi.h
> @@ -18,6 +18,46 @@
>  #define	PCI_ENA_MEMIO	0x02
>  
>  /*
> + * Defines for the SDG embedded board using the XHFC-4SU chip
> + */
> +#ifdef CONFIG_8xx

This seems like a awfully generic name for a (likely global) CONFIG. Can you
add a descriptive prefix?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
