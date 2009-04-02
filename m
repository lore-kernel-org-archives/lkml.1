Return-Path: <linux-kernel-owner+w=401wt.eu-S935444AbZDBHmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935444AbZDBHmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934422AbZDBHmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:42:21 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:44623 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765729AbZDBHmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=aZjH24HQ9Y7DY4ZigVqBDkDbpKeArxJBXTUPCboGKkwqXT9QhMl+U+zhCti0/f/O5e
         J4gLjxgfHtxc8jcscn+67OXT73MTJa5laxZok95M0ZmJRmej3N0Ak7isV5eXtGfMzKaQ
         5+ZH7uJSDfxe9VBsMUyCodjV9hZO1DlMJl5Ls=
MIME-Version: 1.0
In-Reply-To: <20090402055356.GC10642@mit.edu>
References: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com>
	 <20090401225351.GA22621@orion> <20090402055356.GC10642@mit.edu>
Date: Thu, 2 Apr 2009 11:42:17 +0400
Message-ID: <a4423d670904020042x6b76715du48a15e988a05019d@mail.gmail.com>
Subject: Re: 2.6.29-git: cannot mount ext4/loop
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/2 Theodore Tso <tytso@mit.edu>:
> On Thu, Apr 02, 2009 at 02:53:51AM +0400, Alexander Beregalov wrote:
>> On Thu, Apr 02, 2009 at 01:23:28AM +0400, Alexander Beregalov wrote:
>> > Hi Theodore, Jens
>> >
>> > kernel is 2.6.29-07099-g8b53ef3
>> >
>> > Mount failed:
>> >
>> > EXT4-fs: barriers enabled
>> > kjournald2 starting: pid 1867, dev loop0:8, commit interval 5 seconds
>> > EXT4-fs error (device loop0): ext4_iget: block reference 2703228928 >=
>> > max (524288) in inode #2, offset=0
>> > EXT4-fs: get root inode failed
>> > EXT4-fs (device loop0): mount failed
>
> I don't get this failure in a Linux 2.6 kernel based off of 5d80f8e5
> with the )now upstream) ext4 patches merged in.  I'm guessing sometime
> between v2.6.29-3652-g5d80f8e and 2.6.29-07099-g8b53ef3 a regression
> was introduced into the loop driver?

It is sparc host again.
2.6.29-06608-g15f7176 worked fine.
There was one commit to loop.c:
53d66608 (loop: add ioctl to resize a loop device)
and ext4 git pull.

I wil try to revert it and probably bisect.
