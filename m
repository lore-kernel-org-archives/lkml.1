Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbXH0Vmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbXH0Vmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932553AbXH0V3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:29:51 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58879 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932487AbXH0V3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:29:48 -0400
Date: Mon, 27 Aug 2007 23:29:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc3-mm1: i386: -maccumulate-outgoing-args unconditionally
Message-ID: <20070827212948.GJ26410@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm2:
>...
> +x86_64-mm-unwinder.patch
>...
> +x86_64-mm-remove-maccumulate-outgoing-args.patch
>...
>  x86 tree updates
>...

-maccumulate-outgoing-args on i386 count:
1 + 1 - 1 = 1

If the stack unwinder needs it please enable it only explicitely when 
the unwinder is enabled - we are talking about a 2.5% size increase 
with defconfig.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

