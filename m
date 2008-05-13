Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbYEMIeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbYEMIeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:34:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbYEMIdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:33:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:57980 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954AbYEMIds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:33:48 -0400
Message-ID: <482951D0.3070004@yandex.ru>
Date: Tue, 13 May 2008 11:31:12 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com> <1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com> <20080507002345.831bc379.akpm@linux-foundation.org> <20080507080027.GA23621@infradead.org>
In-Reply-To: <20080507080027.GA23621@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 May 2008 08:32:49.0203 (UTC) FILETIME=[ED474830:01C8B4D3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Hellwig wrote:
> I think sync_sb_inodes should just lock/unlock the inode_lock itself as
> per the patch from the reiser4 queue.  But before we export it I'd like
> to review what ubifs actually does with it.

Here is an updated UBIFS tarball for you:
	http://www.infradead.org/~dedekind/ubifs/ubifs-08-05-13.tar.bz2

Did you have chance to do the reviw? We would like to ask for merge at
2.6.27.

> Anyone care to submit a patch to just move the locking that we could
> put in ASAP?

Done, the patch is sitting in our UBIFS.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
