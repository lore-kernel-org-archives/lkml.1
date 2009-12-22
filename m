Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbZLVEhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbZLVEhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 23:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZLVEhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 23:37:00 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:57238 "EHLO
	QMTA08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbZLVEhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 23:37:00 -0500
Message-ID: <4B304D04.6040501@byu.net>
Date: Mon, 21 Dec 2009 21:37:24 -0700
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>
Subject: Re: utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net> <87hbrkjrk8.fsf@devron.myhome.or.jp>
In-Reply-To: <87hbrkjrk8.fsf@devron.myhome.or.jp>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to OGAWA Hirofumi on 12/21/2009 8:05 AM:
>> It may also be file-system dependent.  On the machine where I saw the
>> original failure:
>>> $ uname -a
>>> Linux fencepost 2.6.26-2-xen-amd64 #1 SMP Thu Nov 5 04:27:12 UTC 2009
>>> x86_64 GNU/Linux
>> $ df -T .
>> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
>> /dev/sdb1      xfs   419299328 269018656 150280672  65% /srv/data
> 
> Thanks.
> 
> This is good point. This would be xfs issue or design. xfs seems to have
> own special handling of ctime.

Here's another report, this time about an mtime update not happening on
ntfs-3g.  http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/19336

-- 
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
