Return-Path: <linux-kernel-owner+w=401wt.eu-S1764176AbYD3SPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764176AbYD3SPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758516AbYD3SPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:15:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756636AbYD3SPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:15:43 -0400
Date: Wed, 30 Apr 2008 11:15:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH] iTCO_wdt: ICH9DO support
Message-Id: <20080430111508.2dc5b26c.akpm@linux-foundation.org>
In-Reply-To: <4818875E.7020703@googlemail.com>
References: <4818875E.7020703@googlemail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 16:51:10 +0200
Gabriel C <nix.or.die@googlemail.com> wrote:

> -#define DRV_VERSION     "1.02"
> -#define DRV_RELDATE     "26-Jul-2007"
> +#define DRV_VERSION     "1.03"
> +#define DRV_RELDATE     "30-Apr-2008"

lol.  git-watchdog changes these to

#define DRV_VERSION     "1.10"
#define DRV_RELDATE     "17-Aug-2007"

Version numbers and dates like this really are pretty pointless.  If you
get a report against "v1.10", it just is not useful information.  You still
need to ask "what kernel version" to be able to reliably locate the source
for the reporter's driver.


But it's a great way to generate .rej files.

