Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141Ab0AZXpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab0AZXpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125Ab0AZXpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:45:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:58964 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112Ab0AZXp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:45:28 -0500
Date: Wed, 27 Jan 2010 00:45:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Clean-up a few comments.
In-Reply-To: <1264549178-2874-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1001270043450.30977@pobox.suse.cz>
References: <1264549178-2874-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010, Justin P. Mattock wrote:

> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> ---
>  arch/x86/kernel/setup.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f7b8b98..1bd37e9 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -245,7 +245,7 @@ struct edd edd;
>  #ifdef CONFIG_EDD_MODULE
>  EXPORT_SYMBOL(edd);
>  #endif
> -/**
> +/*

There are zillions of '**' comment starters in kernel sources.

	$ git grep '/\*\*$' drivers/ | wc -l
	15506

So it doesn't seem to make sense to fix only this particular one.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
