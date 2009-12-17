Return-Path: <linux-kernel-owner+w=401wt.eu-S1765083AbZLQUwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765083AbZLQUwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 15:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbZLQUw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 15:52:26 -0500
Received: from mail.perches.com ([173.55.12.10]:1256 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbZLQUw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 15:52:26 -0500
Subject: Re: [PATCH 00/14] kernel.h cleanups
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 12:52:24 -0800
Message-ID: <1261083144.13734.16.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 00:08 -0800, Joe Perches wrote: 
> kernel.h has become a chaotic jumble collected over time.
> Collect the functions and #defines together in logical groups.
> Do some checkpatch neatening and make it more style conformant.

Are there negative attributes in this patchset that
prevent it from being applied?

> Joe Perches (14):
>   kernel.h: Consolidate console and logging functions and defines
>   kernel.h: Checkpatch cleaning
>   kernel.h: ARRAY_SIZE neatening
>   kernel.h: Add argument names to strtoXX, Xscanf prototypes
>   kernel.h: printk neatening
>   drivers/firmware/iscsi_ibft.c: Use %pI4 to print netmask
>   kernel.h: Move NIPQUAD and NIPQUAD_FMT to in.h
>   kernel.h: Group math and limits functions, indent function args
>   kernel.h: Don't use NORET_AND just use noreturn, instead
>   kernel.h: Remove ATTRIB_NORET, use __attribute__((noreturn))
>   kernel.h: Remove uses of NORET_TYPE
>   kernel.h: Add pr_<level>_once
>   kernel.h: Kernel address utility aggregation and other neatening
>   kernel/exit.c and kernel/panic.c: Remove unused NORET_TYPE
> 
>  drivers/firmware/iscsi_ibft.c |    8 +-
>  include/linux/in.h            |   11 +
>  include/linux/kernel.h        |  742 +++++++++++++++++++++++------------------
>  kernel/exit.c                 |    4 +-
>  kernel/panic.c                |    2 +-
>  5 files changed, 437 insertions(+), 330 deletions(-)


