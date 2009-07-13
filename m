Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZGMHt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZGMHt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 03:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZGMHt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 03:49:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33534 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZGMHt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 03:49:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A5AE6E7.2000208@jp.fujitsu.com>
Date: Mon, 13 Jul 2009 16:48:55 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
CC: kexec-ml <kexec@lists.infradead.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-v2] kdump: Enable kdump if 2nd-kernel is loaded.
References: <4A55A4AE.3000206@mxs.nes.nec.co.jp> <4A56E069.5040907@jp.fujitsu.com> <4A5AB903.6090204@mxs.nes.nec.co.jp>
In-Reply-To: <4A5AB903.6090204@mxs.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ken'ichi Ohmichi wrote:
> Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
> Acked-by: Simon Horman <horms@verge.net.au>
> ---
> --- a/kernel/kexec.c	2009-07-08 12:30:26.000000000 +0900
> +++ b/kernel/kexec.c	2009-07-13 13:49:03.000000000 +0900
> @@ -57,7 +57,7 @@ struct resource crashk_res = {
>  
>  int kexec_should_crash(struct task_struct *p)
>  {
> -	if (in_interrupt() || !p->pid || is_global_init(p) || panic_on_oops)
> +	if (kexec_crash_image)
>  		return 1;
>  	return 0;
>  }

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Thanks,
H.Seto

