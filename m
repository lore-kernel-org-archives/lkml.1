Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbYC0Pxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbYC0Pxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 11:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbYC0Px1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 11:53:27 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:45718
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbYC0Px1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 11:53:27 -0400
Message-ID: <47EBC2F5.90302@qumranet.com>
Date: Thu, 27 Mar 2008 17:53:25 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [kvm-devel] kvm causing memory corruption?  ~2.6.25-rc6
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>	 <47EA1C63.8010202@qumranet.com>	 <1206550329.7883.5.camel@nimitz.home.sr71.net>	 <47EA80AC.4070204@qumranet.com>	 <1206551794.7883.7.camel@nimitz.home.sr71.net>	 <47EB6AAC.3040607@qumranet.com> <1206633002.7883.43.camel@nimitz.home.sr71.net>
In-Reply-To: <1206633002.7883.43.camel@nimitz.home.sr71.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2008-03-27 at 11:36 +0200, Avi Kivity wrote:
>   
>> I dug out my i386 install and tried it.  Doesn't reproduce for me on 
>> either kvm.git or -rc7.
>>
>> Do you have a working setup that we can bisect?
>>     
>
> I don't really have a working revision to bisect against.  I'm not sure
> that it ever worked.  

I'm fairly sure Windows works on kvm...

How did you generate the image?

> It's also on my actual laptop, so it's a bit of a
> pain to get any other work done while I'm bisecting. :)
>
> I'll move the Windows image over to another machine today and see if I
> can reproduce elsewhere.  I'll also check some older versions of KVM to
> see if any of those work.  If I do that, should I keep the kvm
> userspace, modules and BIOSes all synchronized from each version that I
> test?
>   

You can keep the userspace (qemu + bios) fixed and change the kernel, or 
vice versa.

-- 
error compiling committee.c: too many arguments to function

