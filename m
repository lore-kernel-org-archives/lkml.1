Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYAYLNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYAYLNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 06:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbYAYLMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 06:12:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:41917 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYAYLMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 06:12:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=upxMgWsV07qkl2dSIMo2kyL+qrS/ZYOe0ufT7wlRXptMsqYGXKQAdhM5QEt93qDnulyI0T3aeGtQOdP0YjajfctgLjnEBf7EiyhjKdDKcyOsPNNsrkbXzwakGneK14ujRksK0UcFM02sCmkz/7NKJQuYPkV6vK5mQl01HrQZsDM=
Message-ID: <4799C42C.7030501@gmail.com>
Date: Fri, 25 Jan 2008 14:12:44 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Heikki Orsila <shdl@zakalwe.fi>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, trivial@kernel.org
Subject: Re: [PATCH 5/9] bfs: move function prototype to the proper header
 file
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com> <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com> <20080124225031.GC12172@zakalwe.fi> <47991B7C.6000208@gmail.com> <Pine.LNX.4.61.0801242318560.8513@ginsburg.homenet> <20080125104217.GA6700@does.not.exist>
In-Reply-To: <20080125104217.GA6700@does.not.exist>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk пишет:
> On Thu, Jan 24, 2008 at 11:22:21PM +0000, Tigran Aivazian wrote:
>> On Fri, 25 Jan 2008, Dmitri Vorobiev wrote:
>>
>>> Heikki Orsila пишет:
>>>>> +extern void dump_imap(const char *, struct super_block *);
>>>>> +
>>>> Functions should not be externed, remove extern keyword.
>>>>
>>> Care to explain why?
>> because dump_imap() is just a BFS' internal helper (for debugging 
>> purposes only btw) to dump the inode map via printk. Why should it be 
>> moved into the header, i.e. where one expects to see things potentially 
>> visible by the rest of the kernel?
>> ...
> 
> fs/bfs/bfs.h is not visible to the rest of the kernel, it's the right 
> place for bfs-internal code.
> 
> Whether there's an "extern" written is just a syntax thing with zero 
> semantical implications. We tend to not write the "extern" in the 
> kernel, but that's nothing cast in stone.

Adrian, thanks for the feedback.

The next version of this patch series will not have the extern keyword
for this helper. I'll try to have the second version sent to trivial
by tomorrow.

Dmitri

