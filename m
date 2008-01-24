Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYAXXRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYAXXRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbYAXXRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:17:11 -0500
Received: from wmsmtp.opaltelecom.net ([62.24.128.253]:46460 "EHLO
	smtp.talktalk.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752353AbYAXXRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:17:10 -0500
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2008 18:17:10 EST
X-Path: TTSMTP
Date: Thu, 24 Jan 2008 23:17:01 +0000 (GMT)
From: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
X-X-Sender: tigran@ginsburg.homenet
To: Heikki Orsila <shdl@zakalwe.fi>
cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 5/9] bfs: move function prototype to the proper header
 file
In-Reply-To: <Pine.LNX.4.61.0801242306400.8407@ginsburg.homenet>
Message-ID: <Pine.LNX.4.61.0801242315410.8486@ginsburg.homenet>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
 <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com>
 <20080124225031.GC12172@zakalwe.fi> <Pine.LNX.4.61.0801242306400.8407@ginsburg.homenet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ooops, I didn't look at the _name_ of the function, i.e. it being 
dump_imap(), an internal helper --- of course it shouldn't be extern'd you 
are right :)

On Thu, 24 Jan 2008, Tigran Aivazian wrote:

> On Fri, 25 Jan 2008, Heikki Orsila wrote:
>> On Fri, Jan 25, 2008 at 01:32:04AM +0300, Dmitri Vorobiev wrote:
>>> diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
>>> index 090b96e..ecc74bb 100644
>>> --- a/fs/bfs/bfs.h
>>> +++ b/fs/bfs/bfs.h
>> ...
>>> +/* inode.c */
>>> +extern void dump_imap(const char *, struct super_block *);
>>> +
>> 
>> Functions should not be externed, remove extern keyword.
>
> why not?
>
> In (roughly, because ^extern pattern is not ideal) 3959 cases only in 
> include/linux/*h they are:
>
> $ grep ^extern include/linux/*h | wc -l
> 3959
>
> Kind regards
> Tigran
>
