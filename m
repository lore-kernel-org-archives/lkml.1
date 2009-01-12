Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbZALIEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbZALIEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZALIEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:04:21 -0500
Received: from mail-gx0-f17.google.com ([209.85.217.17]:50488 "EHLO
	mail-gx0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZALIEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:04:20 -0500
X-Greylist: delayed 37489 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 03:04:20 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Nm7cNYkVmZWpogzwWSP52168YKbAQM6ctwBThU1xhc2NhQozyEvahKjuEVwkvfSZtI
         HYGxtESvEPlnAZ3Q9MQs1u8iEPLNEIUtpdr1hBnObgykb/NXzMrTrZPUQCD3CU7eziro
         SWv5BNy82JLl6mh1azsaawXIhT82fsmR3gMXc=
Message-ID: <21d7e9970901120004t2dd68241x6b9533f489601109@mail.gmail.com>
Date: Mon, 12 Jan 2009 18:04:19 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jan Dittmer" <jdi@l4x.org>
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Cc: "Diego Calleja" <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       eric.anholt@iintel.com, airlied@linux.ie
In-Reply-To: <621d098f0901112342q353326b2k31c276e044ad9d0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com>
	 <621d098f0901110551v5a05f69aqc4e06a6905989d6e@mail.gmail.com>
	 <20090111222122.4d0cb146@diego-desktop>
	 <21d7e9970901111339q705bcea4i44941bfd84a075fe@mail.gmail.com>
	 <621d098f0901112342q353326b2k31c276e044ad9d0a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 5:42 PM, Jan Dittmer <jdi@l4x.org> wrote:
> On Sun, Jan 11, 2009 at 10:39 PM, Dave Airlie <airlied@gmail.com> wrote:
>> On Mon, Jan 12, 2009 at 7:21 AM, Diego Calleja <diegocg@gmail.com> wrote:
>>> I also have a failure with KMS, it's different than yours but I'll post it
>>> in this thread...xserver-xorg-video-intel version 2.5.1 (whatever there is
>>> in ubuntu unstable repositories)
>>
>> Read the kconfig option before you enabled kms by default?
>>
>> if not, you cannot just enable kms and have old userspace drivers
>> work, there is no
>> released userspace for this yet, as that would put the chicken before the egg.
>
> But latest xf86-intel-video git tree should work, shouldn't it? An explicit
> VideoRam line in xorg.conf is ignored btw.

explicit VideoRAM is most likely ignored by xorg as well for Intel
chipsets with the latest driver,
the latest git should work with kms on most chipsets, we are still
chasing down some issues on some chipsets,
its still development code, its mainly upstream to get the API stable
and find the corner cases.

Dave.


>
> Thanks,
>
> Jan
>
> --
> Jan Dittmer <jdi@l4x.org>
>
