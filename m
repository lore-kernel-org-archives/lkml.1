Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbXKGG3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbXKGG3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbXKGG3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:29:06 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49917 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbXKGG3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:29:05 -0500
Message-ID: <47315B39.5060204@us.ibm.com>
Date: Wed, 07 Nov 2007 00:29:13 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Avi Kivity <avi@qumranet.com>,
       Gregory Haskins <gregory.haskins.ml@gmail.com>,
       Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Use of virtio device IDs
References: <4730A15A.6070001@us.ibm.com> <4731334A.6090405@gmail.com> <47314FBD.1070505@qumranet.com> <200711071709.47192.rusty@rustcorp.com.au>
In-Reply-To: <200711071709.47192.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 07 November 2007 16:40:13 Avi Kivity wrote:
>   
>> Gregory Haskins wrote:
>>     
>>>  but FWIW: This is a major motivation for the reason that the
>>> IOQ stuff I posted a while back used strings for device identification
>>> instead of a fixed length, centrally managed namespace like PCI
>>> vendor/dev-id.  Then you can just name your device something reasonably
>>> unique (e.g. "qumranet::veth", or "ibm-pvirt-clock").
>>>       
>> I dislike strings.  They make it look as if you have a nice extensible
>> interface, where in reality you have a poorly documented interface which
>> leads to poor interoperability.
>>     
>
> Yes, you end up with exactly names like "qumranet::veth" 
> and "ibm-pvirt-clock".  I would recommend looking very hard at /proc, Open 
> Firmware on a modern system, or the Xen store, to see what a lack of 
> limitation can do to you :)
>
>   
>> We will support non-pci for s390, but in order to support Windows and
>> older Linux PCI is necessary.
>>     
>
> The aim is that PCI support is clean, but that we're not really tied to PCI.  
> I think we're getting closer with the recent config changes.
>   

Yes, my main desire was to ensure that we had a clean PCI ABI that would 
be natural to implement on a platform like Windows.  I think with the 
recent config_ops refactoring, we can now do that.

Regards,

Anthony Liguori

> Cheers,
> Rusty.
>   

