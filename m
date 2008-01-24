Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbYAXXSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbYAXXSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYAXXS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:18:26 -0500
Received: from wmsmtp.opaltelecom.net ([62.24.128.253]:45999 "EHLO
	smtp.talktalk.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753428AbYAXXSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:18:25 -0500
X-Path: TTSMTP
Date: Thu, 24 Jan 2008 23:08:12 +0000 (GMT)
From: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
X-X-Sender: tigran@ginsburg.homenet
To: Heikki Orsila <shdl@zakalwe.fi>
cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 5/9] bfs: move function prototype to the proper header
 file
In-Reply-To: <20080124225031.GC12172@zakalwe.fi>
Message-ID: <Pine.LNX.4.61.0801242306400.8407@ginsburg.homenet>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
 <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com>
 <20080124225031.GC12172@zakalwe.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008, Heikki Orsila wrote:
> On Fri, Jan 25, 2008 at 01:32:04AM +0300, Dmitri Vorobiev wrote:
>> diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
>> index 090b96e..ecc74bb 100644
>> --- a/fs/bfs/bfs.h
>> +++ b/fs/bfs/bfs.h
> ...
>> +/* inode.c */
>> +extern void dump_imap(const char *, struct super_block *);
>> +
>
> Functions should not be externed, remove extern keyword.

why not?

In (roughly, because ^extern pattern is not ideal) 3959 cases only in 
include/linux/*h they are:

$ grep ^extern include/linux/*h | wc -l
3959

Kind regards
Tigran
