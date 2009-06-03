Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbZFCTAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbZFCTAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbZFCTAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:00:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755625AbZFCTAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:00:07 -0400
Date: Wed, 3 Jun 2009 11:59:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: axboe@kernel.dk, hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       adrian.hunter@nokia.com, artem.bityutskiy@nokia.com
Subject: Re: [PATCH 3/4] FAT: add 'notify' mount option
Message-Id: <20090603115940.bbae3a24.akpm@linux-foundation.org>
In-Reply-To: <22541fc77e43d85acb74cecebdac7523de5cfd72.1244049681.git.ext-denis.2.karpov@nokia.com>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
	<e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com>
	<c3bf79be4fd40b767a94d915e0f7e0cdc8f4cc92.1244049681.git.ext-denis.2.karpov@nokia.com>
	<22541fc77e43d85acb74cecebdac7523de5cfd72.1244049681.git.ext-denis.2.karpov@nokia.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Jun 2009 18:05:17 +0300
Denis Karpov <ext-denis.2.karpov@nokia.com> wrote:

> Implement FAT fs mount option 'notify'. The effect of this option
> is that a notification is sent to userspace on errors that indicate
> filesystem damage/inconsistency. Generic filesystem corruption
> notification mechnism is used.
> 
> Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
> ---
>  fs/fat/fat.h   |    3 ++-
>  fs/fat/inode.c |    9 ++++++++-
>  fs/fat/misc.c  |    7 +++++++

fatfs mount options are documented in
Documentation/filesystems/vfat.txt, please.

