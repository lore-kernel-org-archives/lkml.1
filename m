Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbXJBIjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbXJBIjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXJBIj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:39:28 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:55872 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751788AbXJBIj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:39:28 -0400
Message-ID: <391314365.29871@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 2 Oct 2007 16:39:22 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: writeback fixes
Message-ID: <20071002083922.GA28892@mail.ustc.edu.cn>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 02:22:22PM -0700, Andrew Morton wrote:
[...] 
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
> writeback-fix-comment-use-helper-function.patch
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch

> writeback-fix-periodic-superblock-dirty-inode-flushing.patch

I have 4 more patches on writeback, 3 of them fix *new* problems that
was introduced by the above patch. I'd recommend to merge them as a
whole - either for 2.6.24 or for 2.6.25.

I'll post them right now.

Fengguang

> introduce-i_sync.patch
> introduce-i_sync-fix.patch
> writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch
> 
>   Merge

