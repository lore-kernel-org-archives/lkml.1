Return-Path: <linux-kernel-owner+w=401wt.eu-S1761943AbXGJBAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761943AbXGJBAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760628AbXGJBAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 21:00:38 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33584 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761722AbXGJBAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 21:00:36 -0400
Date: Mon, 09 Jul 2007 18:03:43 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 1/4] try parent numa_node at first before using default
In-reply-to: <20070710004416.GA6905@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com,
       rientjes@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <4692DAEF.7040106@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <200707031835.l63IZo9K008197@imap1.linux-foundation.org>
 <200707031731.02456.yinghai.lu@sun.com> <20070710004416.GA6905@kroah.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Jul 03, 2007 at 05:31:02PM -0700, Yinghai Lu wrote:
>> [PATCH 1/4] try parent numa_node at first before using default
>>
> 
> What is this going to give us?
you can use dev_to_node(netdev->dev) or dev_to_node(usb_device->dev) directly, and don't need to go to find pci_device up to get numa_node.
> 
> Doesn't it mean that all devices will end up on the same node?
yes.
For x86_64, devices under node1 will have 1, and device under node0 will all have 0.

current only pci_dev->dev.numa_node is used.

YH


