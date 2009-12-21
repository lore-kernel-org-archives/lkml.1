Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZLUKco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZLUKco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 05:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZLUKcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 05:32:43 -0500
Received: from ozlabs.org ([203.10.76.45]:35419 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbZLUKcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 05:32:43 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Fix BUILD_BUG_ON in fs/compat_ioctl.c to build with gcc 4.5 snapshot
Date: Mon, 21 Dec 2009 21:02:39 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, rguenther@suse.de, arnd@arndb.de
References: <20091220165315.GA13208@basil.fritz.box>
In-Reply-To: <20091220165315.GA13208@basil.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912212102.39878.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009 03:23:15 am Andi Kleen wrote:
> Fix BUILD_BUG_ON in fs/compat_ioctl.c to build with gcc 4.5 snapshot
> 
> The BUILD_BUG_ON in compat_ioctl_check_table() fails
> with a recent gcc mainline snapshot (gcc version 4.5.0 20091219)
> (GCC)), even though it works with older compilers.

We have a proper fix for BUILD_BUG_ON which I sent Linus a pull req for,
but I think it was too late:

	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git BUILD_BUG_ON

It's not really high priority, but it'd be nice to fix this properly.

Thanks,
Rusty.
