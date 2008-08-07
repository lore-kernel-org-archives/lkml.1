Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbYHGMzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbYHGMzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYHGMzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:55:17 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:39775 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbYHGMzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:55:16 -0400
X-Greylist: delayed 1995 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2008 08:55:15 EDT
Message-ID: <489AE3C5.2000807@grupopie.com>
Date: Thu, 07 Aug 2008 13:00:05 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kallsyms exclude local symbols
References: <87fxphzan5.wl%ysato@users.sourceforge.jp>
In-Reply-To: <87fxphzan5.wl%ysato@users.sourceforge.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yoshinori Sato wrote:
> h8300's nm output include '.Lfoo' local symbols.
> [...]
>  	/* exclude also MIPS ELF local symbols ($L123 instead of .L123) */
> -	else if (str[0] == '$')
> +	else if (str[0] == '$' || str[0] == '.')

The comment above needs some updating too. Something along these lines:

/* exclude also MIPS ELF local symbols (eg. $L123) and h8300 (eg .LM10) */

Other than that, the patch seems fine.

-- 
Paulo Marques - www.grupopie.com

"...so she told me it was either her or the ham radio, over."
