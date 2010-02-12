Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab0BLXHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:07:46 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:43135 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0BLXHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:07:45 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Graham M Howe <gman.1352@googlemail.com>
Subject: Re: [PATCH 2/2] Staging: comedi: fix bracing and 80 character stylein ni_at_a2150.c This is a patch to the ni_at_a2150.c file to fix up bracing and 80 character warnings  found by the checkpatch.pl tool Signed-off-by: Graham M Howe <gman.1352@googlemail.com>
Date: Sat, 13 Feb 2010 00:07:38 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
References: <1266015937-3532-1-git-send-email-user@graham-eeepc>
In-Reply-To: <1266015937-3532-1-git-send-email-user@graham-eeepc>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002130007.38863.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 13. Februar 2010 00:05:37 schrieb Graham M Howe:
> --- a/drivers/staging/comedi/drivers/ni_at_a2150.c
> +++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
> @@ -86,8 +86,10 @@ TRIG_WAKE_EOS
>  #define   CLOCK_SELECT_BITS(x)         (((x) & 0x3) << 3)
>  #define   CLOCK_DIVISOR_BITS(x)                (((x) & 0x3) << 5)
>  #define   CLOCK_MASK           (0xf << 3)
> -#define   ENABLE0_BIT          0x80    /*  enable (don't internally ground) channels 0 and 1 */
> -#define   ENABLE1_BIT          0x100   /*  enable (don't internally ground) channels 2 and 3 */
> +/*  enable (don't internally ground) channels 0 and 1 */
> +#define   ENABLE0_BIT          0x80
> +/*  enable (don't internally ground) channels 2 and 3 */

Does this really improve readability?

	Regards
		Oliver
