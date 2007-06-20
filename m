Return-Path: <linux-kernel-owner+w=401wt.eu-S1759750AbXFTIlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750AbXFTIlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 04:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXFTIlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 04:41:36 -0400
Received: from mail-relay-02.mailcluster.net ([85.249.135.243]:52030 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbXFTIlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 04:41:35 -0400
Message-ID: <4678E81C.5000608@vlnb.net>
Date: Wed, 20 Jun 2007 12:41:00 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: david@lang.hm
Cc: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
References: <20070612161029.GB28279@think.oraclecorp.com> <4676C2D6.8030708@vlnb.net> <46779DB1.7060807@draigBrady.com> <4677A972.6030909@vlnb.net> <Pine.LNX.4.64.0706191118180.25045@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706191118180.25045@asgard.lang.hm>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
>>> > 3. De-de-duplicate blocks on disk, i.e. copy them on write
>>> > > I suppose that de-duplication itself would be done by some user 
>>> space
>>> > process that would scan files, determine blocks with the same data and
>>> > then de-duplicate them by using syscall or IOCTL (2).
>>> > > That would be very usable feature, which in most cases would 
>>> allow to
>>> > shrink occupied disk space on 50-90%.
>>>
>>>  Have you references for this number?
>>
>>
>> No, I've seen it somewhere and it well confirms with my own observations.
>>
>>>  In my experience one gets a lot of benefit from
>>>  the much simpler process of "de-duplication" of files.
>>
>>
>> Yes, sure, de-duplication on files level brings its benefits, but on 
>> FS blocks level it would bring ever more benefits, because there are 
>> many more or less big files, which are different as a whole, but with 
>> a lot of the same blocks. Simple example of such files is UNIX-style 
>> mail boxes on a mail server.
> 
> 
> unix style mail boxes would not be a good example of wins for 
> sector-based de-duplication since the duplicate mail is not going to be 
> sector aligned.

Yes, I realized that after I sent the e-mail. Handling of the same, but 
not aligned, data in different files would need more complex logic. 
Maybe too complex.

Vlad
