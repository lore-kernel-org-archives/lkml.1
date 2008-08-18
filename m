Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbYHRWDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbYHRWDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYHRWDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:03:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45585 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYHRWDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:03:44 -0400
Message-ID: <48A9F1BC.40002@zytor.com>
Date: Mon, 18 Aug 2008 15:03:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: create device, function symlinks in	/sys/bus/pci/slots/N/
References: <20080818202100.GE23155@ldl.fc.hp.com>
In-Reply-To: <20080818202100.GE23155@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Create convenience symlinks in sysfs, linking slots to devices
> and functions, and vice versa. These links make it easier for
> users to figure out which devices actually live in what slots.
> 
> The device symlink points to the device's first function.
> 
> For example:
> 
> sapphire:/sys/bus/pci/slots # ls
> 1  10  2  3  4  5  6  7  8  9
> 
> sapphire:/sys/bus/pci/slots # ls -l 3
> total 0
> -r--r--r-- 1 root root 65536 Aug 18 14:10 address
> lrwxrwxrwx 1 root root     0 Aug 18 14:10 device -> ../../../../devices/pci0000:23/0000:23:01.0
> lrwxrwxrwx 1 root root     0 Aug 18 14:10 function0 -> ../../../../devices/pci0000:23/0000:23:01.0
> lrwxrwxrwx 1 root root     0 Aug 18 14:10 function1 -> ../../../../devices/pci0000:23/0000:23:01.1
> 

What's the point with "device" and "function0"?  They appear to be the 
same thing by definition.

	-hpa
