Return-Path: <linux-kernel-owner+w=401wt.eu-S1751365AbZIHPjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbZIHPjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 11:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbZIHPjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 11:39:51 -0400
Received: from mail2.shareable.org ([80.68.89.115]:45736 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZIHPjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 11:39:51 -0400
Date: Tue, 8 Sep 2009 16:39:49 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH take 3][RFC] fat: Save FAT root directory timestamps to volume label
Message-ID: <20090908153949.GD5579@shareable.org>
References: <1252420131.5782.2.camel@jorg-desktop> <1252420448-7282-1-git-send-email-ext-jorg.2.schummer@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252420448-7282-1-git-send-email-ext-jorg.2.schummer@nokia.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jorg Schummer wrote:
> Standard FAT implementations cannot store any of the FAT root directory's
> timestamps. This commit adds the mount option 'rootts', which allows saving
> the FAT root directory timestamps as the timestamps of the FAT volume label
> directory entry. At least Mac OS X is known to support the same mechanism
> and interoperate with this commit.
> 
> When mounting, the following values can be specified for the 'rootts' mount
> option:
> 
>   "rootts=ignore"   ignores root directory timestamps. All timestamps are
>                     reset to 0 (1/1/1970). This has been the FAT behaviour
>                     prior to this patch.
> 
>   "rootts=preserve" tries to load and save the root directory's timestamps
>                     if a volume label entry exists. The mtime and atime are
>                     corrected based on root directory entries' ctime. This
>                     is the default.
> 
>   "rootts=save"     tries to load and save the root directory's timestamps.
>                     The mtime and atime are corrected based on root
>                     directory entries' ctime. If the root directory was
>                     accessed but no volume label entry exists, the label
>                     "NO NAME" is created.

Does Mac OS X do the same "NO NAME" thing?

-- Jamie
