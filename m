Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYJXC6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYJXC6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 22:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYJXC6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 22:58:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:28063 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYJXC6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 22:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=B1g+QDSFikLHuRznfwkBYb1F92k7yX4kaX8Rc3bcsIe1SJJnaO34sW9doY7TE2liyQ
         znxbeDJGiLlopaH6uIIPfo+A++abod45djY9O2l2v1n5ZQ45eot2OeJfeP16pk0Lrjly
         VWbAMXouK7NiIBIoaeth7S+rxKSXMS+rDymbA=
Message-ID: <43e72e890810231958n2ef4f709k86e3d3adf81f5f73@mail.gmail.com>
Date: Thu, 23 Oct 2008 19:58:06 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Shaohua Li" <shaohua.li@intel.com>
Subject: Re: CONFIG_PCIEASPM needed for ASPM?
Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081024024747.GA3900@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890810231840t2b5dd812p50d2325a967e6d4@mail.gmail.com>
	 <20081024024747.GA3900@sli10-desk.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 7:47 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Fri, Oct 24, 2008 at 09:40:27AM +0800, Luis R. Rodriguez wrote:
>> I know, the question is silly right? I thought so too, but I started
>> reviewing the code and noticed most of it is just setting up values in
>> data structures for the kernel's awareness of capabilities, it also
>> updates the state in case of BIOS foobar, and there is also clock
>> retraining if possible to reduce latency. Is that it? Did I miss
>> something or is it really possible for devices to be able to use
>> L0s|L1 or L1 by just having a BIOS which does things correctly?
>>
>> That is can our devices be using ASPM without any OS interaction,
>> without CONFIG_PCIEASPM enabled?
> you didn't miss anything. If BIOS enables ASPM, even OS doesn't do anything,
> ASPM will be used.

I see, interesting... how about the clock selection and training? The
ASPM code has it, but without it will it have taken place in hardware
behind the scenes?

> ASPM enter/leave is controlled by hardware, OS just
> enables the capability.

What do you mean by the OS enabling the capability? All I see is
setting the capability bits on the pci struct so the OS can reflect
this internally and to userspace, say through lspci. Is that it?

  Luis
