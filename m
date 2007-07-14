Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbXGND4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbXGND4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 23:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbXGND4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 23:56:05 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:8922 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbXGND4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 23:56:04 -0400
Date: Fri, 13 Jul 2007 21:58:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: One Vendor/Device ID multiple instances of driver
In-reply-to: <fa.6cQieg/J+91tnyM674iETzYudjY@ifi.uio.no>
To: Keith Chew <keith.chew@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <469849C8.9080409@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.6cQieg/J+91tnyM674iETzYudjY@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Chew wrote:
> Hi
> 
> We have a WIFI driver that only supports a single device at a time. We
> want to use 2 devices with the same vendor/device ID, but spawn 2
> instances of the same driver. Each instance will handle a single
> device.
> 
> If we bought the devices from 2 vendors, we'd have 2 DeviceIDs, we can
> modify the driver to look at different IDs, which will solve our
> problem. But how can we achieve this if we wanted to use the same
> device from the same vendor?

The most obvious response is, why does the driver support only a single 
device at a time? Fixing that would be the best solution, as this goes 
against all kernel convention.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

