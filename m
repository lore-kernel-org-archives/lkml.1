Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbYIQOmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbYIQOmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYIQOl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:41:58 -0400
Received: from lazybastard.de ([212.112.238.170]:34802 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYIQOl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:41:57 -0400
Date: Wed, 17 Sep 2008 16:41:47 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Seiji Kihara <kihara.seiji@lab.ntt.co.jp>,
       Yoshiji Amagai <amagai.yoshiji@lab.ntt.co.jp>
Subject: Re: [PATCH 25/27] nilfs2: block cache for garbage collection
Message-ID: <20080917144146.GD8750@logfs.org>
References: <1221419304-18572-17-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-18-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-19-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-20-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-21-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-22-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-23-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-24-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-25-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-26-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1221419304-18572-26-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 September 2008 04:08:22 +0900, Ryusuke Konishi wrote:
> 
> This adds the cache of on-disk blocks to be moved in garbage
> collection.  The disk blocks are held with dummy inodes (called
> gcinodes), and this file provides lookup function of the dummy inodes,
> and their buffer read function.

Nice explanation.  Can you add it to the comment header at the top of
the file?  Unlike the GPL preample, it actually helps non-lawyers. ;)

Using dummy inodes is... unusual.  Why can you not use the actual inodes
those blocks belong to?  Or alternatively a single inode that simply
covers the complete physical device?

Jörn

-- 
All models are wrong. Some models are useful.
-- George Box
