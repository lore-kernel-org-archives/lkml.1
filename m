Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYK0LYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYK0LYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 06:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYK0LYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 06:24:31 -0500
Received: from www.tglx.de ([62.245.132.106]:55632 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbYK0LYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 06:24:31 -0500
Date: Thu, 27 Nov 2008 12:23:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@googlemail.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 02/24] perfmon: base code
In-Reply-To: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com>
Message-ID: <alpine.LFD.2.00.0811271202240.3325@localhost.localdomain>
References: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

On Wed, 26 Nov 2008, eranian@googlemail.com wrote:

> +/*
> + * pfmfs should _never_ be mounted by userland - too much of security hassle,
> + * no real gain from having the whole whorehouse mounted. So we don't need
> + * any operations on the root directory. However, we need a non-trivial
> + * d_name - pfm: will go nicely and kill the special-casing in procfs.
> + */

Can we please use anon_inodefs instead of creating a new one ? It's
exaclty for this purpose.

See fs/anon_inodes.c and fs/timerfd.c for an usage example.

Thanks,

	tglx
