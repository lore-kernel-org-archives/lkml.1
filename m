Return-Path: <linux-kernel-owner+w=401wt.eu-S937392AbYEUUrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937392AbYEUUrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762851AbYEUUrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:47:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60413 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbYEUUra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:47:30 -0400
Date: Wed, 21 May 2008 22:47:28 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jike Song <albcamus@gmail.com>
cc: sam@ravnborg.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [.gitignore] match ncscope.out
In-Reply-To: <4834CAFE.2070607@gmail.com>
Message-ID: <alpine.LNX.1.10.0805212246390.15136@fbirervta.pbzchgretzou.qr>
References: <4834CAFE.2070607@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-22 03:23, Jike Song wrote:
> ---
> .gitignore |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/.gitignore b/.gitignore
> index 090b293..a48b1e1 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -51,7 +51,7 @@ patches
> series
>
> # cscope files
> -cscope.*
> +*cscope.*

Unless you know there is acscope, bcscope, etc. I'd rather add
just ncscope.* instead of the catches-more *cscope.*.
