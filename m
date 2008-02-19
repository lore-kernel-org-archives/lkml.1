Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbYBSPVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbYBSPVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYBSPVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:21:43 -0500
Received: from mail.syneticon.net ([213.239.212.131]:53732 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYBSPVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:21:42 -0500
Message-ID: <47BAF3FF.3070300@wpkg.org>
Date: Tue, 19 Feb 2008 16:21:35 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
References: <47B980AC.2080806@wpkg.org> <20080218141640.GC12568@mit.edu> <47BAED94.3040103@wpkg.org> <200802191006.50693.chris.mason@oracle.com>
In-Reply-To: <200802191006.50693.chris.mason@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason schrieb:
> On Tuesday 19 February 2008, Tomasz Chmielewski wrote:
>> Theodore Tso schrieb:
>>
>> (...)
>>
>>> The following ld_preload can help in some cases.  Mutt has this hack
>>> encoded in for maildir directories, which helps.
>> It doesn't work very reliable for me.
>>
>> For some reason, it hangs for me sometimes (doesn't remove any files, rm
>> -rf just stalls), or segfaults.
> 
> You can go the low-tech route (assuming your file names don't have spaces in 
> them)
> 
> find . -printf "%i %p\n" | sort -n | awk '{print $2}' | xargs rm

Why should it make a difference?

Does "find" find filenames/paths faster than "rm -r"?

Or is "find once/remove once" faster than "find files/rm files/find 
files/rm files/...", which I suppose "rm -r" does?


-- 
Tomasz Chmielewski
http://wpkg.org
