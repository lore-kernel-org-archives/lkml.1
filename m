Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039Ab0AVOxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0AVOxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641Ab0AVOxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:53:46 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:35117 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab0AVOxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:53:46 -0500
Date: Fri, 22 Jan 2010 08:52:34 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 24/38] move round_up/down to kernel.h
In-Reply-To: <1264152287-13866-25-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.00.1001220851210.2704@router.home>
References: <1264152287-13866-1-git-send-email-yinghai@kernel.org> <1264152287-13866-25-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010, Yinghai Lu wrote:

> +#define __round_mask(x,y) ((__typeof__(x))((y)-1))
> +#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
> +#define round_down(x,y) ((x) & ~__round_mask(x,y))

s/round/round_power2/


>  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))

Also some uppercase/lowercase mess.

