Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbZJ1AIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbZJ1AIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 20:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbZJ1AIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 20:08:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58672 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbZJ1AIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 20:08:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AE78B88.5000105@s5r6.in-berlin.de>
Date: Wed, 28 Oct 2009 01:08:40 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Re: Zillions of warnings in -next
References: <20091027152530.75ca60e4@lxorguk.ukuu.org.uk>	 <4AE7258D0200005A000576F6@sinclair.provo.novell.com>	 <20091027222112.74058162@lxorguk.ukuu.org.uk>	 <20091027153651.6d636fe8.randy.dunlap@oracle.com> <1256685917.29938.79.camel@Joe-Laptop.home>
In-Reply-To: <1256685917.29938.79.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Tue, 2009-10-27 at 15:36 -0700, Randy Dunlap wrote:
[...]
>> @@ -643,7 +644,7 @@ eventq_wakeup(struct ioq_notifier *notif
>>  		struct ioq_ring_desc *desc  = iter.desc;
>>  		struct vbus_pci_event *event;
>>  
>> -		event = (struct vbus_pci_event *)desc->cookie;
>> +		event = (struct vbus_pci_event *)(unsigned long)desc->cookie;
>>  
>>  		switch (event->eventid) {
>>  		case VBUS_PCI_EVENT_DEVADD:
> 
> #define cast_cookie(type, cookie) ((type)(unsigned long)(cookie))
> #define assign_cookie(var, cookie) (var) = ((typeof(var))(unsigned
> long)(cookie))

C is usually preferred over cpp. :-)
-- 
Stefan Richter
-=====-==--= =-=- ===--
http://arcgraph.de/sr/
