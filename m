Return-Path: <linux-kernel-owner+w=401wt.eu-S965737AbXDGTaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737AbXDGTaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 15:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966304AbXDGTaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 15:30:05 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:53463 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965737AbXDGTaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 15:30:03 -0400
Message-ID: <4617F12D.8080905@namesys.com>
Date: Sat, 07 Apr 2007 23:29:49 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Laurent Riffard <laurent.riffard@free.fr>
CC: Ignatich <ignatich@gmail.com>, reiserfs-list@namesys.com,
       linux-kernel@vger.kernel.org
Subject: Re: REISER4: fix for reiser4_write_extent
References: <46157B5B.5000602@gmail.com> <461793E4.5040706@free.fr>
In-Reply-To: <461793E4.5040706@free.fr>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Riffard wrote:

> Le 06.04.2007 00:42, Ignatich a écrit :
>
>> While trying to find the cause of problems with reiser4 in recent 
>> kernels I came across this.
>>
>> Incomplete write handling seem to be missing from 
>> reiser4_write_extent() thanks to reiser4-temp-fix.patch. Strangely, 
>> there is a patch by Edward Shishkin that should address that issue, 
>> but it is missing from -mm tree. Please check.
>>
>>    Max
>>
>
> This patch was added to -mm tree the 14 Dec 2006 (see 
> http://www.mail-archive.com/mm-commits@vger.kernel.org/msg05338.html).
>
> It was then dropped from -mm tree the 05 Mar 2007 (see 
> http://www.mail-archive.com/mm-commits@vger.kernel.org/msg10818.html), 
> with this comment:
>     "This patch was dropped because it is obsolete"
>
> No idea why it was obsolete. Does somebody know ?


This uses not settled interface filemap_copy_from_user_atomic/nonatomic
However, those things should be fixed. I'll prepare the patch a bit later..

Thanks,
Edward.
