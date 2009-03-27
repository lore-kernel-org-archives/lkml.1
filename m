Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZC0IF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZC0IF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 04:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZC0IFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 04:05:34 -0400
Received: from tundra.namei.org ([65.99.196.166]:3353 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbZC0IFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 04:05:32 -0400
Date: Fri, 27 Mar 2009 19:04:46 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: TOMOYO in linux-next
In-Reply-To: <200903270412.n2R4CG7o054009@www262.sakura.ne.jp>
Message-ID: <alpine.LRH.2.00.0903271904320.15928@tundra.namei.org>
References: <20090326215031.GD29836@elf.ucw.cz> <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org> <200903270412.n2R4CG7o054009@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009, Tetsuo Handa wrote:

> ----------------------------------------
> TOMOYO: Fix a typo.
> 
> Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
> ---
>  security/tomoyo/common.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.29-git1.orig/security/tomoyo/common.h
> +++ linux-2.6.29-git1/security/tomoyo/common.h
> @@ -55,7 +55,7 @@ struct tomoyo_path_info {
>  struct tomoyo_path_info_with_data {
>  	/* Keep "head" first, for this pointer is passed to tomoyo_free(). */
>  	struct tomoyo_path_info head;
> -	char bariier1[16]; /* Safeguard for overrun. */
> +	char barrier1[16]; /* Safeguard for overrun. */
>  	char body[TOMOYO_MAX_PATHNAME_LEN];
>  	char barrier2[16]; /* Safeguard for overrun. */
>  };
> 

Applied.

-- 
James Morris
<jmorris@namei.org>
