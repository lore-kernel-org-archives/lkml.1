Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbXKHXvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbXKHXvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 18:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763420AbXKHXvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 18:51:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:27710 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762060AbXKHXu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 18:50:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=rh0CN9YXjBCfXJ12Sej5Vtt1FjueRymdmva0VuC32f2WB2hr28VZ4i7IDuJP9N0eWoCy97hEBdYw7Mwxau1NC6iGSIzVAIqj7ncdebX9v/eywzSwpZ0egvtaeYpwTkdongXTdcaaZQBL/kV/gSUAVXlW2zCsuWmzdDulEP8eSTk=
Message-ID: <47339F20.6010602@qumranet.com>
Date: Fri, 09 Nov 2007 01:43:28 +0200
Reply-To: dor.laor@qumranet.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: Avi Kivity <avi@qumranet.com>, Rusty Russell <rusty@rusycorp.com.au>,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com>	<11944900163817-git-send-email-aliguori@us.ibm.com>	<4732A8E5.6090307@qumranet.com> <47331531.8070709@us.ibm.com>
In-Reply-To: <47331531.8070709@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dor Laor <dor.laor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Avi Kivity wrote:
>   
>> Anthony Liguori wrote:
>>   
>>     
>>> This is a PCI device that implements a transport for virtio.  It allows virtio
>>> devices to be used by QEMU based VMMs like KVM or Xen.
>>>
>>>   
>>>     
>>>       
>> Didn't see support for dma.
>>     
>
> Not sure what you're expecting there.  Using dma_ops in virtio_ring?
>
>   
>>  I think that with Amit's pvdma patches you
>> can support dma-capable devices as well without too much fuss.
>>   
>>     
>
> What is the use case you're thinking of?  A semi-paravirt driver that 
> does dma directly to a device?
>
> Regards,
>
> Anthony Liguori
>
>   
You would also lose performance since pv-dma will trigger an exit for 
each virtio io while
virtio kicks the hypervisor after several IOs were queued.
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >> http://get.splunk.com/
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel
>
>   

