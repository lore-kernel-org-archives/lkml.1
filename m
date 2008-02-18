Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbYBRPC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbYBRPC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYBRPCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:02:46 -0500
Received: from mail.syneticon.net ([213.239.212.131]:49722 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYBRPCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:02:44 -0500
Message-ID: <47B99E0C.8020706@wpkg.org>
Date: Mon, 18 Feb 2008 16:02:36 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu>
In-Reply-To: <20080218141640.GC12568@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso schrieb:

(...)

>> What has helped a bit was to recreate the file system with -O^dir_index
>> dir_index seems to cause more seeks.
> 
> Part of it may have simply been recreating the filesystem, not
> necessarily removing the dir_index feature.

You mean, copy data somewhere else, mkfs a new filesystem, and copy data 
back?

Unfortunately, doing it on a file level is not possible with a 
reasonable amount of time.

I tried to copy that filesystem once (when it was much smaller) with 
"rsync -a -H", but after 3 days, rsync was still building an index and 
didn't copy any file.


Also, as files/hardlinks come and go, it would degrade again.


Are there better choices than ext3 for a filesystem with lots of 
hardlinks? ext4, once it's ready? xfs?


-- 
Tomasz Chmielewski
http://wpkg.org
