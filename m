Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbXBNBMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbXBNBMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932217AbXBNBMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:12:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218AbXBNBMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:12:35 -0500
Message-ID: <45D26222.9040504@redhat.com>
Date: Tue, 13 Feb 2007 20:13:06 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Daniel Barkalow <barkalow@iabervon.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: Is this bug too obvious?
References: <45D25ABE.5080400@redhat.com> <Pine.LNX.4.64.0702132000220.20138@iabervon.org>
In-Reply-To: <Pine.LNX.4.64.0702132000220.20138@iabervon.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Barkalow wrote:
> On Tue, 13 Feb 2007, Chuck Ebbert wrote:
> 
>> drivers/usb/net/usbnet.c:
>>
>> int
>> usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>> {
>>         struct usbnet                   *dev;
>>         struct net_device               *net;
>>         struct usb_host_interface       *interface;
>>         struct driver_info              *info;
>>         struct usb_device               *xdev;
>>         int                             status;
>>
>> 	...
>>
>>         net = alloc_etherdev(sizeof(*dev));
>>                                     ^^^^
>> 	                            *net ???
> 
> No, alloc_etherdev takes the size of the private data, which, in this 
> case, is *dev.
> 
> 	-Daniel
> *This .sig left intentionally blank*

OK I'll keep looking for the cause of the oops then:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=228231

