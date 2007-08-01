Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbXHANxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbXHANxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXHANxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:53:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:30522 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762266AbXHANxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:53:30 -0400
Message-ID: <fa686aa40708010653v7e1fb909gb03eb1d4754359bf@mail.gmail.com>
Date: Wed, 1 Aug 2007 07:53:28 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [2.6 patch] ppc .gitignore update
Cc: "Rutger Nijlunsing" <rutger@nospam.com>,
       "Paul Mackerras" <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070801133056.GP3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070801133056.GP3972@stusta.de>
X-Google-Sender-Auth: 37849d3c11e55727
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Adrian Bunk <bunk@stusta.de> wrote:
> arch/ppc/.gitignore shouldn't exclude arch/ppc/boot/include
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
> ---
> --- /dev/null   2006-09-19 00:45:31.000000000 +0200
> +++ linux-2.6.23-rc1-mm2/arch/ppc/boot/.gitignore       2007-08-01 15:18:33.000000000 +0200
> @@ -0,0 +1 @@
> +!include

I don't think this is the best way to go about it; rather,
arch/ppc/.gitignore should be made more specific like so:

diff --git a/arch/ppc/.gitignore b/arch/ppc/.gitignore
index a1a869c..1e79a0a 100644
--- a/arch/ppc/.gitignore
+++ b/arch/ppc/.gitignore
@@ -1 +1 @@
-include
+/include

>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
>


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
