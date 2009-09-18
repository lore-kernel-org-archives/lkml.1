Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbZIRSCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbZIRSCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 14:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbZIRSCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 14:02:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:34693 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179AbZIRSCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 14:02:13 -0400
Message-ID: <4AB3CB25.2080808@codemonkey.ws>
Date: Fri, 18 Sep 2009 13:02:13 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alan Cox <alan@linux.intel.com>, Amit Shah <amit.shah@redhat.com>,
       rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic
 guest and host communication
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com>	<1252678386-17404-2-git-send-email-amit.shah@redhat.com>	<20090911170010.34c80f2d@linux.intel.com>	<20090911163806.GB25535@amit-x200.redhat.com>	<4AAA8838.1080106@codemonkey.ws>	<20090911173307.GB27046@amit-x200.redhat.com>	<4AAA8A56.3040707@codemonkey.ws>	<20090916112332.6bf981a5@linux.intel.com>	<4AB164A0.8000402@codemonkey.ws> <20090918170048.53ba8cf6@linux.intel.com> <4AB3C988.2040303@codemonkey.ws> <4AB3CA27.1040307@zytor.com>
In-Reply-To: <4AB3CA27.1040307@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 09/18/2009 10:55 AM, Anthony Liguori wrote:
>   
>> I fail to see how this is at all relevant.  This is a virtual machine,
>> we're presenting virtual hardware that behaves like a serial device. 
>> Where web servers fit in is completely beyond me.
>>
>>     
>
> s/virtio_console/virtio_serial/
>
> There is a fairly noticeable difference between a "console device" and a
> "serial device".  However, something that can be extended and exported
> to a physical serial port is definitely the latter.
>   

Indeed.  I think part of the confusion here is that virtio_console 
started as just as console and hence it used hvc.  As part of the 
current reworking, I think it makes sense to rename the driver 
virtio_serial.

Regards,

Anthony Liguori

> 	-hpa
>
>   

