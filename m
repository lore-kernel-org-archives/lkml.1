Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbYEVKzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbYEVKzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYEVKy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:54:58 -0400
Received: from smtp.nokia.com ([192.100.122.230]:35091 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYEVKy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:54:57 -0400
Message-ID: <483550C5.1010100@yandex.ru>
Date: Thu, 22 May 2008 13:53:57 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>	<1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com>	<20080507002345.831bc379.akpm@linux-foundation.org>	<48218F21.4090304@yandex.ru>	<20080507083835.6ba126e6.akpm@linux-foundation.org>	<4832C7FF.2090904@yandex.ru> <20080520104907.e77ae05d.akpm@linux-foundation.org>
In-Reply-To: <20080520104907.e77ae05d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 May 2008 10:53:59.0179 (UTC) FILETIME=[237ECDB0:01C8BBFA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Artem Bityutskiy <dedekind@yandex.ru> wrote:
>> is it OK for you if ubifs-2.6.git will have some patches which ubi-2.6.git
>> also contains. Will your -mm system handle this?
> 
> It happens occasionally and I usually manage to work it out.  Sometimes
> with git hackery, sometimes manually.  It'd be better if it was a
> once-off thing, rather than having new conflicts arise each time I
> repull the trees, if possible.

OK. The thing is that we'd like to have UBI patches in UBIFS tree to give
them a test. So what I've done I've created a branch named "for_andrew".
Could you please switch your scripts from "master" branch to "for_andrew"
branch? This branch will have the same but UBI patches which are already
in the UBI tree and would cause conflicts.

Thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
