Return-Path: <linux-kernel-owner+w=401wt.eu-S1161425AbXDWL0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161425AbXDWL0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 07:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161429AbXDWL0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 07:26:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:41525 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161425AbXDWLZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 07:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F5hQlFm/qLrr264nWsqGjAky4XhWFpx/rp/kV8FonGVZQeC8Sj0myhsOVjsePj85u6YviyRb7+TfP+UcNITN+QUO314c+1wrVFGj3U5l+xs/l/Ssy468UsEHyAcQ0cJu6vD13/03M90ykhMrY4fKxs3LS7+m1S7swCsLP70cUX8=
Message-ID: <2e4afe1e0704230425vb66892la4cc3c2ef14a1470@mail.gmail.com>
Date: Mon, 23 Apr 2007 16:55:52 +0530
From: "Karuna sagar K" <karunasagark@gmail.com>
To: "Kalpak Shah" <kalpak@linsyssoft.com>
Subject: Re: Testing framework
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1177319379.4579.13.camel@garfield>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2e4afe1e0704221346u6d6baec1uab88dc273ff08de9@mail.gmail.com>
	 <1177319379.4579.13.camel@garfield>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/07, Kalpak Shah <kalpak@linsyssoft.com> wrote:
> On Mon, 2007-04-23 at 02:16 +0530, Karuna sagar K wrote:

.....
>> The file system is looked upon as a set of blocks (more precisely
>> metadata blocks). We randomly choose from this set of blocks to
>> corrupt. Hence we would be able to overcome the deficiency of the
>> previous approach. However this approach makes it difficult to have a
>> replayable corruption. Further thought about this approach has to be
>> given.
>
> Fill a test filesystem with data and save it. Corrupt it by copying a
> chunk of data from random locations A to B. Save positions A and B so
> that you can reproduce the corruption.
>

Hey, thats a nice idea :). But, this woundnt reproduce the same
corruption right? Because, say, on first run of the tool there is
metadata stored at locations A and B and then on the second run there
may be user data present. I mean the allocation may be different.

> Or corrupt random bits (ideally in metadata blocks) and maintain the
> list of the bit numbers for reproducing the corruption.
>

.....
>> The corrupted file system is repaired and recovered with 'fsck' or any
>> other tools; this phase considers the repair and recovery action on
>> the file system as a black box. The time taken to repair by the tool
>> is measured
>
> I see that you are running fsck just once on the test filesystem. It
> might be a good idea to run it twice and if second fsck does not find
> the filesystem to be completely clean that means it is a bug in fsck.

You are right. Will modify that.

>
> <snip>
>

......
>> State of the either file system is stored, which may be huge, time
>> consuming and not necessary. So, we could have better ways of storing
>> the state.
>
> Also, people may want to test with different mount options, so something
> like "mount -t $fstype -o loop,$MOUNT_OPTIONS $imgname $mountpt" may be
> useful. Similarly it may also be useful to have MKFS_OPTIONS while
> formatting the filesystem.
>

Right. I didnt think of that. Will look into it.

> Thanks,
> Kalpak.
>
> >
> > Comments are welcome!!
> >
> > Thanks,
> > Karuna
>
>

Thanks,
Karuna
