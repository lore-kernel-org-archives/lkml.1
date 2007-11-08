Return-Path: <linux-kernel-owner+w=401wt.eu-S1760430AbXKHNzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430AbXKHNzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 08:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbXKHNzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 08:55:13 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:42060 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120AbXKHNzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 08:55:11 -0500
Message-ID: <47331531.8070709@us.ibm.com>
Date: Thu, 08 Nov 2007 07:54:57 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rusycorp.com.au>,
       virtualization@lists.osdl.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com> <11944900163817-git-send-email-aliguori@us.ibm.com> <4732A8E5.6090307@qumranet.com>
In-Reply-To: <4732A8E5.6090307@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Anthony Liguori wrote:
>   
>> This is a PCI device that implements a transport for virtio.  It allows virtio
>> devices to be used by QEMU based VMMs like KVM or Xen.
>>
>>   
>>     
>
> Didn't see support for dma.

Not sure what you're expecting there.  Using dma_ops in virtio_ring?

>  I think that with Amit's pvdma patches you
> can support dma-capable devices as well without too much fuss.
>   

What is the use case you're thinking of?  A semi-paravirt driver that 
does dma directly to a device?

Regards,

Anthony Liguori


