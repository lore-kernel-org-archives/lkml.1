Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbYBDTh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbYBDTh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYBDThR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:37:17 -0500
Received: from styx.suse.cz ([82.119.242.94]:50422 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752598AbYBDThP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:37:15 -0500
Date: Mon, 4 Feb 2008 20:37:14 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] udf: next round of cleanups
Message-ID: <20080204193714.GO3426@duck.suse.cz>
References: <1202063631-18145-1-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202063631-18145-1-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 03-02-08 19:33:45, marcin.slusarz@gmail.com wrote:
> Hi
> 
> This patchset contains next round of various UDF fs cleanups.
> 
> [PATCH 1/6] udf: udf_get_block, inode_bmap - remove unneeded checks
> 
> [PATCH 2/6] udf: create function for conversion from timestamp to timespec
> [PATCH 3/6] udf: convert udf_stamp_to_time to return struct timespec
> [PATCH 4/6] udf: convert udf_stamp_to_time and udf_time_to_stamp to use timestamps
> [PATCH 5/6] udf: remove unneeded kernel_timestamp type
> These 4 patches can be folded into one if requested, but I think it's
> easier to analyze them when they are split.
> 
> [PATCH 6/6] udf: super.c reorganization
> Pretty mechanical work. Can be dropped and redone if it will
> conflict with someone else patch.
> 
>  fs/udf/ecma_167.h |   13 -
>  fs/udf/inode.c    |  183 ++++++-----------
>  fs/udf/super.c    |  553 ++++++++++++++++++++++++++----------------------------
>  fs/udf/udfdecl.h  |    8 
>  fs/udf/udfend.h   |   22 --
>  fs/udf/udftime.c  |   39 +--
>  6 files changed, 358 insertions(+), 460 deletions(-)
> 
> Applies on top of patches I've sent lately (http://lkml.org/lkml/2008/1/30/482)
> 
> Jan: Are you going to create git tree for udf?
  I was already thinking about it to take some burden from Andrew. So if
you think you are going to have more time for these cleanups then I can
setup one (it would be useless when I send to Andrew one fix per month ;)...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
