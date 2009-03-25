Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbZCYFZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbZCYFZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbZCYFZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:25:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbZCYFZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:25:10 -0400
Message-ID: <49C9C163.8040502@suse.de>
Date: Wed, 25 Mar 2009 13:30:11 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-03-23-22-34 uploaded (reiserfs)
References: <200903240539.n2O5d6A8018954@imap1.linux-foundation.org> <49C9483B.1030905@oracle.com>
In-Reply-To: <49C9483B.1030905@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Randy Dunlap Wrote:
> akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2009-03-23-22-34 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
>>
>> and will soon be available at
>>
>>    git://git.zen-sources.org/zen/mmotm.git
>>
>> It contains the following patches against 2.6.29-rc8:
> 
> 
>> fs-reiserfs-return-f_fsid-for-statfs2-v2.patch
> 
> fs/built-in.o: In function `reiserfs_statfs':
> super.c:(.text+0x7332b): undefined reference to `crc32_le'
> super.c:(.text+0x7333f): undefined reference to `crc32_le'
> 
Hmm, it should not be. The v2 patch includes linux/crc32.h, and I tested without
any error. Now I am downloading mmotm to verify.

BTW, from series file of mmotm, I see two version patches,
fs-reiserfs-return-f_fsid-for-statfs2.patch
fs-reiserfs-return-f_fsid-for-statfs2-v2.patch
are all included. I suspect whether this is a proper behavior.

Thanks.
-- 
Coly Li
SuSE Labs
