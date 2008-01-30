Return-Path: <linux-kernel-owner+w=401wt.eu-S1761441AbYA3LRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441AbYA3LRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbYA3LRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:17:22 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:45587 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbYA3LRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:17:21 -0500
Message-ID: <47A05CBA.2030903@grupopie.com>
Date: Wed, 30 Jan 2008 11:17:14 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@analog.com>
CC: linux-kernel@vger.kernel.org, Robin Getz <robin.getz@analog.com>
Subject: Re: [PATCH 1/1] [Kallsyms] Blackfin: Allow kernel symbols in L1 to
 be found
References: <1201688453-1763-1-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1201688453-1763-1-git-send-email-bryan.wu@analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Robin Getz <robin.getz@analog.com>
> [...]
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -12,6 +12,8 @@
>   * (25/Aug/2004) Paulo Marques <pmarques@grupopie.com>
>   *      Changed the compression method from stem compression to "table lookup"
>   *      compression
> + * (10/Jul/2006) Robin Getz <rgetz@blackfin.uclinux.org>
> + *      Add _stext_l1, _etext_l1 for the L1 memory section in Blackfin.

When I wrote this initially, it was a mistake to add a Changelog in the 
first place, but I didn't know better at the time.

If you're going to make changes to this file, please remove all the 
Changelog, instead of adding more entries to it. The "Changelog" should 
be kept by the version control system, and not the source code itself.

The rest of the patch looks ok, though.

-- 
Paulo Marques - www.grupopie.com

"Very funny Scotty. Now beam up my clothes."
