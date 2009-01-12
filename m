Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZALHm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZALHm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 02:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZALHmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 02:42:17 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:45425 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZALHmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 02:42:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kBe/Jc97+bfn+EPG9JdJuOvbx0zpB700hTUnhN4ARbJAMn3sjtIVxUdb5rBk4R863Y
         IRiLqtrEH8k1eiQHnWQV39LMV9Kp1yGj74x0186Csvxg+lWnnc0p84B1uC2CFsIOqKKT
         QLDreF//xfI9dZZlAQv8cqmF6WVZmqz1fYi5M=
Message-ID: <621d098f0901112342q353326b2k31c276e044ad9d0a@mail.gmail.com>
Date: Mon, 12 Jan 2009 08:42:14 +0100
From: "Jan Dittmer" <jdi@l4x.org>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Cc: "Diego Calleja" <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       eric.anholt@iintel.com, airlied@linux.ie
In-Reply-To: <21d7e9970901111339q705bcea4i44941bfd84a075fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com>
	 <621d098f0901110551v5a05f69aqc4e06a6905989d6e@mail.gmail.com>
	 <20090111222122.4d0cb146@diego-desktop>
	 <21d7e9970901111339q705bcea4i44941bfd84a075fe@mail.gmail.com>
X-Google-Sender-Auth: a4c2a0e0f867728c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 10:39 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Mon, Jan 12, 2009 at 7:21 AM, Diego Calleja <diegocg@gmail.com> wrote:
>> I also have a failure with KMS, it's different than yours but I'll post it
>> in this thread...xserver-xorg-video-intel version 2.5.1 (whatever there is
>> in ubuntu unstable repositories)
>
> Read the kconfig option before you enabled kms by default?
>
> if not, you cannot just enable kms and have old userspace drivers
> work, there is no
> released userspace for this yet, as that would put the chicken before the egg.

But latest xf86-intel-video git tree should work, shouldn't it? An explicit
VideoRam line in xorg.conf is ignored btw.

Thanks,

Jan

-- 
Jan Dittmer <jdi@l4x.org>
