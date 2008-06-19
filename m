Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbYFSLMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbYFSLMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 07:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbYFSLMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 07:12:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:3444 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbYFSLMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 07:12:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ks+WL6sfrCAqtcmAMiKD/O/wAFdQFQNcaxkAHutuJhwjmDaphV4qJjt+SxH38JYELk
         bDL+WKls6ck/1gnL3rmBUeijaFyxPMaY9+JSuqNT0QIKs2LkBfCAvfr1jO6STr8I9xBN
         jOJeUuhJAfx0YTM7HXrMAqNPJmexq3shQO1QQ=
Message-ID: <bc64b4640806190412m70cbb15dr76a25ecb99c245dc@mail.gmail.com>
Date: Thu, 19 Jun 2008 15:12:38 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: ian <spyro@f2s.com>
Subject: Re: [PATCH] MFD maintainer
Cc: "pHilipp Zabel" <philipp.zabel@gmail.com>,
       "Samuel Ortiz" <sameo@openedhand.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ben Dooks" <ben-linux@fluff.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
In-Reply-To: <1213872881.17281.32.camel@wirenth>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080618214223.GE22566@caravaggio>
	 <74d0deb30806190259l2ff7931fo819ededc7aec02f7@mail.gmail.com>
	 <1213872881.17281.32.camel@wirenth>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/6/19 ian <spyro@f2s.com>:
> Hi guys!
>
> Good timing! I just sat down with the e-series code last night!
>
> I'd like to see the MFD core make it into mainline, and then we can
> start pushing the TMIO drivers too.
>
> These drivers are in a LOT of handhelds and I'd really like to see the
> code move to mainline now.
>
> The code is maturing well - I just bumped all the eseries stuff, which
> includes the core MFD code and all the TMIO drivers from 2.6.24 to
> 2.6.26-git and the only issue was some minor #include breakage.
>
> I'll tidy up the code and pop a branch on my git server for people to
> review, if thats what people want.

It's better to send patches to some ML.

>
> Dmitry - if you have any pending patches now is the time to send them on
> over ;-)

Actually the code I'm using has diverged a bit from the last code I've
sent before this merging pulse.
As you have seen, I've tried to submit parts of the core and tmio-nand
driver as a start. Then I'd suggest
to merge other tmio core bits (support for tc6387xb and t7l66xb). The
MMC, usb and fb cell drivers could
benefit from clocklib patches I'm trying to get in. I'll submit the
updated version of mfd-core patch this evening,
however some other bits will require more time from my side.

>
> -Ian
>
> On Thu, 2008-06-19 at 11:59 +0200, pHilipp Zabel wrote:
>> Added Ian, Dmitry and Russell to Cc.
>>
>> On Wed, Jun 18, 2008 at 11:42 PM, Samuel Ortiz <sameo@openedhand.com> wrote:
>> > Hi,
>> >
>> > We probably need someone to look after the few drivers/mfd patches coming
>> > every now and then. As agreed with Andrew, I'm ok to do so and my employer
>> > is fine with me spending a few working hours on it, if needed.
>>
>> Right now quite some of the MFD patches go through arm-kernel, but I
>> guess once that initial rush of ARM machine patches depending on MFD
>> patches submitted at the same time is over, it's a very good idea to
>> have a proper path into the kernel.

Yeah!

-- 
With best wishes
Dmitry
