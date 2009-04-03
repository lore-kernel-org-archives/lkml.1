Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbZDCFPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbZDCFPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 01:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZDCFPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 01:15:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:25064 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZDCFPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 01:15:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=HqVidvXMENJfkIxWJiilTBHyeyHx0NNkuKn+QLJ9zDS0TogkYyKH4ookohqVGpY7vW
         1PcQDtT8Tal37SRh/2T1zXLJvqZiubU5dLmgBs53neslTr/fHmmqSEGTsXzxlQ1dP8Wh
         MglVjQ3+mrAtHH++zlLkZynEogY+AHFryJ9QE=
MIME-Version: 1.0
In-Reply-To: <20090403050246.GM9870@mit.edu>
References: <49CCCB0A.6070701@nokia.com>
	 <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
	 <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com>
	 <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com>
	 <72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com>
	 <9b1675090904021905o7e0cec64lfe4a5372777908b6@mail.gmail.com>
	 <72dbd3150904021919g5405ee40p100eacb085024941@mail.gmail.com>
	 <9b1675090904021928k5a9948f9l8d93b6cbd5531720@mail.gmail.com>
	 <72dbd3150904021958q7795dc62keb54d1fbfaa6abc7@mail.gmail.com>
	 <20090403050246.GM9870@mit.edu>
Date: Thu, 2 Apr 2009 23:15:29 -0600
Message-ID: <9b1675090904022215u612a3c06g98c3dcf3e74571a2@mail.gmail.com>
Subject: Re: EXT4-ish "fixes" in UBIFS
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 11:02 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Apr 02, 2009 at 07:58:17PM -0700, David Rees wrote:
>>
>> I've got a problematic server with 8GB RAM.  Even if set both to 1,
>> that's 80MB and the crappy disks I have in it will often only write
>> 10-20MB/s or less due to the seekiness of the workload.  That means
>> delays of 5-10 seconds worst case which isn't fun.
>>
>
> People will still be better off moving to ext4, but for people who
> aren't quite confident in ext4's stability yet and who want to stick
> with ext3, maybe it's a good short-term solution.  Maybe
> data=writeback with the rename hueristic would be a better default
> than data=ordered for ext3.
>
>                                                - Ted
>

I've tried that before...

tdamac ~ # mount -t ext3 -o data=writeback,remount,rw /dev/s/sys /
mount: / not mounted already, or bad option

Does it have to be done on initial mount?
