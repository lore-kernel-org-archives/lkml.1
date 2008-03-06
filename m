Return-Path: <linux-kernel-owner+w=401wt.eu-S1762676AbYCFISk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762676AbYCFISk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 03:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYCFIS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 03:18:27 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18012 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbYCFIS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 03:18:26 -0500
Date: Thu, 6 Mar 2008 09:18:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: jeff@garzik.org
Subject: Re: ahci: work around ATI SB600 h/w quirk
Message-ID: <20080306081822.GO6704@kernel.dk>
References: <200803060259.m262x3tp008780@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803060259.m262x3tp008780@hera.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06 2008, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a878539ef994787c447a98c2e3ba0fe3dad984ec
> Commit:     a878539ef994787c447a98c2e3ba0fe3dad984ec
> Parent:     6ddd68615ae9b21096545d7d6ab0f04113ae8b42
> Author:     Jeff Garzik <jeff@garzik.org>
> AuthorDate: Thu Feb 28 15:43:48 2008 -0500
> Committer:  Jeff Garzik <jeff@garzik.org>
> CommitDate: Wed Mar 5 07:53:06 2008 -0500
> 
>     ahci: work around ATI SB600 h/w quirk
>     
>     This addresses the recent ATI SB600 errata, where the hardware does
>     not like 256-length PRD entries during FPDMA (aka NCQ).
>     
>     It hurts performance on SB600, but it is more important to get a
>     correct patch eliminating the data corruption/lockups, and then later
>     on tune for performance.
>     
>     We simply limit each command to a maximum of 255 sectors, on SB600.

Why not limit it to 255 segments, if that's the real issue?

-- 
Jens Axboe

