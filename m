Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbXDZC0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbXDZC0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 22:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbXDZC0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 22:26:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:53888 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbXDZC0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 22:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=j4c44chNvbuOJBdNgqvc3DTg33IQBJJgnX8wpDIQhr5fRs3ZhEiixKmsldA7pIDWZTGWG774lbqtL+S3U91fmCSjEtylN9+zT8co5Oep33Tqgv+kcuc+ihPVRgrWLX74k0AXp0VLq2VkcvbH8/PrwF9qp3vyTJwK8Z23DEP2pbo=
Message-ID: <46300DDC.1070805@gmail.com>
Date: Thu, 26 Apr 2007 11:26:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Antonino A. Daplas" <adaplas@gmail.com>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Nonfunctional ethernet (was Re: 2.6.21-rc7-mm1 + sysfs-oops-workaround.patch
 -- INFO: possible recursive locking detected)
References: <a44ae5cd0704242215w1b474c52r7860f0d49bc64d6c@mail.gmail.com>	<462EE4B7.6000708@gmail.com>	<1177512528.4856.15.camel@daplas>	<1177544702.4668.9.camel@daplas>	<1177549323.4685.3.camel@daplas> <20070425181302.ebae7481.akpm@linux-foundation.org>
In-Reply-To: <20070425181302.ebae7481.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Antonino, Andrew.

Andrew Morton wrote:
> On Thu, 26 Apr 2007 09:02:02 +0800 "Antonino A. Daplas" <adaplas@gmail.com> wrote:
> 
>> I can bring up the network manually using ifconfig.  It's opensuse's
>> rcnetwork script that fails to bring the network up. Entries
>> in /sys/class/net are still bogus.
>>
>> This kernel is now usable to me, I'll start bisection later today if
>> nobody has an answer.
> 
> rc7-mm1 is hardly worth bothering with.  Quite a few really bad ones have
> now been fixed and I'll try to get rc7-mm2 out within the next 12 hours (I
> assume a 76-hour debug session won't be needed this time).
> 
> But I don't think the sysfs changes in Greg's tree have been updated, so
> things will probably still fail in that area.  A suitable bisection
> starting pair would be around gregkh-driver-*

This is the rename bug I wrote about in the other thread.  Can you hold
-mm2 off a bit?  I'm almost done here.

Thanks.

-- 
tejun
