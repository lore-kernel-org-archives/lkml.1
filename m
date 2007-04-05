Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXDEUiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXDEUiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbXDEUiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:38:08 -0400
Received: from ms01.sssup.it ([193.205.80.99]:34255 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753170AbXDEUiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:38:05 -0400
Message-ID: <20070405223802.xdw94s8lxcgcsw0w@feanor.sssup.it>
Date: Thu, 05 Apr 2007 22:38:02 +0200
From: trimarchi@gandalf.sssup.it
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: vfb module
References: <4614B388.7050002@gandalf.sssup.it>
	<1175798570.5549.1.camel@daplas>
In-Reply-To: <1175798570.5549.1.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.1) / FreeBSD-6.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
>> I changed a little bit the vfb module to be used as a frame buffer in
>> memory. I would like to use the mmap over the virtual framebuffer. I
>> added a few line:
>> I allocated the buffer using
>> videomemory=(void *)__get_free_pages(GFP_KERNEL,
>> get_order(PAGE_ALIGN(videomemorysize)));
>>
>> and fixed the framebuffer info structure:
>>
>> vfb_fix.smem_start = virt_to_phys(videomemory);
>> vfb_fix.smem_len = videomemorysize;
>>
>> What is the virtual frame buffer meant for?
>
> For testing, and some uses it as a skeleton for another driver.

I want to use for debugging purpose in embedded system in emulation  
enviroment.
Regards Michael


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

