Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZJAWhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZJAWhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZJAWhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:37:39 -0400
Received: from mail.perches.com ([173.55.12.10]:1600 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZJAWhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:37:39 -0400
Subject: Re: [PATCH] LED driver for Intel NAS SS4200 series (v4)
From: Joe Perches <joe@perches.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rpurdie@rpsys.net, rgirod@confocus.com,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1254436115-7595-1-git-send-email-dave@sr71.net>
References: <1254436115-7595-1-git-send-email-dave@sr71.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Oct 2009 15:37:42 -0700
Message-Id: <1254436662.1799.117.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 15:28 -0700, Dave Hansen wrote:
> Changes from last version
> * Changed logging functions to use cleaner helpers
> diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
[]
> +#ifdef pr_fmt
> +#undef pr_fmt
> +#endif
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Hi Dave.

Thanks for doing this.

Minor nit: I think the preferred style is to
put the #define pr_fmt before any #include.

cheers, Joe


