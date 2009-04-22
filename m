Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZDVUfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZDVUfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbZDVUew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:34:52 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12143 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZDVUev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:34:51 -0400
Message-ID: <49EF7F34.9040401@caviumnetworks.com>
Date: Wed, 22 Apr 2009 13:33:56 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: coly.li@suse.de
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/7] mips cavium-octeon: add parameter to octeon_cvmcount_read()
References: <49EF6A9E.6080605@suse.de>
In-Reply-To: <49EF6A9E.6080605@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2009 20:33:56.0937 (UTC) FILETIME=[A8F58B90:01C9C389]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coly Li wrote:
> This patch modifies parameter of octeon_cvmcount_read() from 'void' to 'struct
> clocksource *cs', which fixes compile warning for incompatible parameter type.
> 
> Signed-off-by: Coly Li <coly.li@suse.de>
> Cc: David Daney <ddaney@caviumnetworks.com>
> Cc: Ingo Molnar <mingo@elte.hu>

It looks good to me:

Reviewed-by: David Daney <ddaney@caviumnetworks.com>


> ---
>  arch/mips/cavium-octeon/csrc-octeon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/mips/cavium-octeon/csrc-octeon.c
> b/arch/mips/cavium-octeon/csrc-octeon.c
> index 70fd92c..96110f2 100644
> --- a/arch/mips/cavium-octeon/csrc-octeon.c
> +++ b/arch/mips/cavium-octeon/csrc-octeon.c
> @@ -38,7 +38,7 @@ void octeon_init_cvmcount(void)
>  	local_irq_restore(flags);
>  }
> 
> -static cycle_t octeon_cvmcount_read(void)
> +static cycle_t octeon_cvmcount_read(struct clocksource *cs)
>  {
>  	return read_c0_cvmcount();
>  }
> 

