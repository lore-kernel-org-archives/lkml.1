Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbXH1IIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbXH1IIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 04:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXH1IHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 04:07:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47080 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbXH1IHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 04:07:52 -0400
Date: Tue, 28 Aug 2007 01:07:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] i386: unexport machine_id
Message-Id: <20070828010741.19fccb06.akpm@linux-foundation.org>
In-Reply-To: <20070827212808.GT4121@stusta.de>
References: <20070827212808.GT4121@stusta.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 23:28:08 +0200 Adrian Bunk <bunk@kernel.org> wrote:

> This patch removes the unused EXPORT_SYMBOL(machine_id).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> This patch has been sent on:
> - 14 Aug 2007
> 
> --- a/arch/i386/kernel/setup.c
> +++ b/arch/i386/kernel/setup.c
> @@ -86,9 +86,6 @@ unsigned long mmu_cr4_features;
>  
>  /* for MCA, but anyone else can use it if they want */
>  unsigned int machine_id;
> -#ifdef CONFIG_MCA
> -EXPORT_SYMBOL(machine_id);
> -#endif
>  unsigned int machine_submodel_id;
>  unsigned int BIOS_revision;
>  unsigned int mca_pentium_flag;

You know my position on removal of exports with no warning.

If the relevant maintainer chooses to apply the patch then ho hum I have
other things to think about.  Your best shot at getting this sort of thing
merged would be to cc the appropriate maintainer.

Or, better, use __deprecated_for_modules.  That's what it was added for.
