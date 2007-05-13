Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbXEMSWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbXEMSWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbXEMSWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:22:39 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:49556 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbXEMSWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:22:38 -0400
Date: Sun, 13 May 2007 21:22:26 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
Message-ID: <20070513182226.GA8658@localdomain>
References: <20070513132517.GA14038@localdomain> <20070513092352.18cd80de@freepuppy> <20070513171555.GA27920@localdomain> <46475324.7050303@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46475324.7050303@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 10:04:20PM +0400, Michael Tokarev wrote:
> There are two issues (IMHO anyway), both are userspace.
> 
> First is the ability blacklist the given module from bootloader.
> My initramfs has it since the beginning - it allows a noload=xxx
> paramerer (comma-separated list of module patterns, cumulative),
> for exactly this purpose.  I implemented modprobe in shell (not
> using a binary from module-init-tools) for initramfs (it's some
> 20 lines of shell code).  Because of exactly that reason - on
> certain systems i had a problem with certain drivers, resulting
> in boot failures.  Later on, this set of modules gets transformed
> into a modprobe blacklist list.  It's trivial to do.
> 
> And second is what to do with direct insmod invocations in minimal
> embedded system startup sequence.  Well, minimal it or not, but
> shell is present anyhow, so I don't see any problem with that,
> either...

Yes, I guess a shell script can always look at /proc/cmdline with
relatively minimal complexity.

Anyway, it all boils down to whether there's a developer demand 
for a userspace-independent way of blacklisting modules. Let's see 
if more people post their opinion so we can determine.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
