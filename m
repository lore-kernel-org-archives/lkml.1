Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbYENK44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbYENK44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 06:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbYENK4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 06:56:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:58669 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506AbYENK4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 06:56:46 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: Novell, SuSE Labs
To: Tiger Yang <tiger.yang@oracle.com>
Subject: Re: [PATCH] ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
Date: Wed, 14 May 2008 12:56:42 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
References: <4827B878.50903@oracle.com> <20080512170254.f79fe869.akpm@linux-foundation.org> <4828FD68.40608@oracle.com>
In-Reply-To: <4828FD68.40608@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805141256.43272.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2008 04:31:04 Tiger Yang wrote:
> Hi, Andrew
>
> This situation only happens we format ext3/4 with inode size more than
> 128 and we have put xattr entries both in ibody and block.
> The consequences about this bug is we will lost the xattr block which
> pointed by i_file_acl with all xattr entires in it. We will alloc a new
> xattr block and put that large value entry in it. The old xattr block
> will become orphan block.

The patch looks good, and it obviously fixes the described problem. Thanks!

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>


Could it please be added to -stable?

Andreas
