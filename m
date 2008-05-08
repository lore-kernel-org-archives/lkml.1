Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbYEHKMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbYEHKMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbYEHKL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:11:57 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35861 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604AbYEHKL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:11:56 -0400
Message-ID: <4822D1B6.60005@yandex.ru>
Date: Thu, 08 May 2008 13:11:02 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>      <1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com>  <20080507002345.831bc379.akpm@linux-foundation.org>     <48218F21.4090304@yandex.ru> <20080507083835.6ba126e6.akpm@linux-foundation.org> <4821DF13.2010207@yandex.ru>
In-Reply-To: <4821DF13.2010207@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 May 2008 10:11:26.0345 (UTC) FILETIME=[E01ABF90:01C8B0F3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> I've split the original patch on 3 pieces:
> 1. VFS: move inode_lock into sync_sb_inodes
> 2. VFS: export sync_sb_inodes
> 3. VFS: introduce sync_inodes superblock operation
> 
> The first 2 are exactly what UBIFS also needs. The third one is only
> needed for Reiser4. The patches are attached.
Well, assuming this is ok with you I've drop our VFS patch and pushed
the above patches 1 and 2 instead.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
