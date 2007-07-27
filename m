Return-Path: <linux-kernel-owner+w=401wt.eu-S964973AbXG0Lgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973AbXG0Lgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 07:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933873AbXG0Lgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 07:36:35 -0400
Received: from www.sophics.cz ([194.108.6.2]:44611 "EHLO www.sophics.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933655AbXG0Lge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 07:36:34 -0400
X-Greylist: delayed 2392 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 07:36:33 EDT
Message-ID: <46A9CF66.90108@sophics.cz>
Date: Fri, 27 Jul 2007 12:56:38 +0200
From: Petr Stehlik <pstehlik@sophics.cz>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Yoann Padioleau <padator@wanadoo.fr>
CC: kernel-janitors@vger.kernel.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/68] 0 -> NULL, for arch/m68k
References: <200707270944.LAA17213@ifs.emn.fr>
In-Reply-To: <200707270944.LAA17213@ifs.emn.fr>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yoann Padioleau wrote:
> When comparing a pointer, it's clearer to compare it to NULL than to 0.

>  	stram_start = phys_to_virt(0);
> -	kernel_in_stram = (stram_start == 0);
> +	kernel_in_stram = (stram_start == NULL);

stram_start is more like an offset than pointer, IMHO. And 0 is a valid 
offset. The "==NULL" does not make much sense in this particular case. 
NULL is usually used when checking for an uninitialized pointer, right?

Petr

