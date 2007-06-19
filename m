Return-Path: <linux-kernel-owner+w=401wt.eu-S1761244AbXFSSUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244AbXFSSUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbXFSSUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:20:45 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:44357
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217AbXFSSUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:20:44 -0400
Date: Tue, 19 Jun 2007 11:20:29 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Vladislav Bolkhovitin <vst@vlnb.net>
cc: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
In-Reply-To: <4677A972.6030909@vlnb.net>
Message-ID: <Pine.LNX.4.64.0706191118180.25045@asgard.lang.hm>
References: <20070612161029.GB28279@think.oraclecorp.com> <4676C2D6.8030708@vlnb.net>
 <46779DB1.7060807@draigBrady.com> <4677A972.6030909@vlnb.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Vladislav Bolkhovitin wrote:

>> > 3. De-de-duplicate blocks on disk, i.e. copy them on write
>> > 
>> > I suppose that de-duplication itself would be done by some user space
>> > process that would scan files, determine blocks with the same data and
>> > then de-duplicate them by using syscall or IOCTL (2).
>> > 
>> > That would be very usable feature, which in most cases would allow to
>> > shrink occupied disk space on 50-90%.
>>
>>  Have you references for this number?
>
> No, I've seen it somewhere and it well confirms with my own observations.
>
>>  In my experience one gets a lot of benefit from
>>  the much simpler process of "de-duplication" of files.
>
> Yes, sure, de-duplication on files level brings its benefits, but on FS 
> blocks level it would bring ever more benefits, because there are many more 
> or less big files, which are different as a whole, but with a lot of the same 
> blocks. Simple example of such files is UNIX-style mail boxes on a mail 
> server.

unix style mail boxes would not be a good example of wins for sector-based 
de-duplication since the duplicate mail is not going to be sector aligned.

David Lang

