Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbYBMV47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbYBMV47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932677AbYBMVe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:34:58 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:29392 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669AbYBMVe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:34:57 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] make secmark_tg_destroy() static
Date: Wed, 13 Feb 2008 16:34:51 -0500
User-Agent: KMail/1.9.7
Cc: James Morris <jmorris@namei.org>, coreteam@netfilter.org,
       linux-kernel@vger.kernel.org
References: <20080213212940.GH3383@cs181133002.pp.htv.fi>
In-Reply-To: <20080213212940.GH3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131634.51116.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 4:29:40 pm Adrian Bunk wrote:
> This patch makes the needlessly global secmark_tg_destroy() static.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks for catching this.

Acked-by: Paul Moore <paul.moore@hp.com>

> ---
> df66d8d74309b41298ae011532fd284aad3ed2ba
> diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
> index 7708e20..c028485 100644
> --- a/net/netfilter/xt_SECMARK.c
> +++ b/net/netfilter/xt_SECMARK.c
> @@ -111,7 +111,7 @@ secmark_tg_check(const char *tablename, const
> void *entry, return true;
>  }
>
> -void secmark_tg_destroy(const struct xt_target *target, void
> *targinfo) +static void secmark_tg_destroy(const struct xt_target
> *target, void *targinfo) {
>  	switch (mode) {
>  	case SECMARK_MODE_SEL:

-- 
paul moore
linux security @ hp
