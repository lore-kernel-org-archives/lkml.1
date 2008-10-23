Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYJWX6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYJWX6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYJWX6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:58:30 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:33863 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbYJWX62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OV+IOC92zc+mxx0kVZA1pb5bV3j6Vg40sptdHhrI+//4jMDhRMWZJg6MBm1+Zd8DO3
         SnJ7dhv9AeOyMib8K47gHgsnWTN/wYv25UbPQpPDXiKplI9REOL47LAUd1x11BiPbaSk
         55KYCd06KcEeMdMGHx79ormPoSEyoiQgmt4PE=
Message-ID: <a4423d670810231658i6e7a9146je64240e99c1c512a@mail.gmail.com>
Date: Fri, 24 Oct 2008 03:58:23 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: Re: build failure at x86/kernel/pci-dma.c with !CONFIG_PCI
Cc: LKML <linux-kernel@vger.kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
       "Woodhouse, David" <david.woodhouse@intel.com>, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, mingo@elte.hu,
       fujita.tomonori@lab.ntt.co.jp, adobriyan@gmail.com
In-Reply-To: <20081023235100.GA2192@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670810231609h76323d2fqa4ed7d9ba0a46e3b@mail.gmail.com>
	 <20081023235100.GA2192@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/24 Fenghua Yu <fenghua.yu@intel.com>:
> On Thu, Oct 23, 2008 at 04:09:52PM -0700, Alexander Beregalov wrote:
>> arch/x86/kernel/built-in.o: In function `iommu_setup':
>> pci-dma.c:(.init.text+0x36ad): undefined reference to `forbid_dac'
>> pci-dma.c:(.init.text+0x36cc): undefined reference to `forbid_dac'
>> pci-dma.c:(.init.text+0x3711): undefined reference to `forbid_dac
>>
>> commit 5b6985ce8ec7127b4d60ad450b64ca8b82748a3b
>> Author: Fenghua Yu <fenghua.yu@intel.com>
>> Date:   Thu Oct 16 18:02:32 2008 -0700
>>
>>     intel-iommu: IA64 support
>
> Could you please try the following fix patch?
>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
It works fine for me on x86_32
