Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYHSPxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYHSPxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYHSPx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:53:26 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:19308 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYHSPxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:53:24 -0400
Date: Tue, 19 Aug 2008 09:53:23 -0600
From: Alex Chiang <achiang@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: jbarnes@virtuousgeek.org, matthew@wil.cx, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: create device, function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080819155323.GA18842@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
	matthew@wil.cx, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080818202100.GE23155@ldl.fc.hp.com> <48A9F1BC.40002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A9F1BC.40002@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin <hpa@zytor.com>:
> Alex Chiang wrote:
>> Create convenience symlinks in sysfs, linking slots to devices
>> and functions, and vice versa. These links make it easier for
>> users to figure out which devices actually live in what slots.
>>
>> The device symlink points to the device's first function.
>>
>> For example:
>>
>> sapphire:/sys/bus/pci/slots # ls
>> 1  10  2  3  4  5  6  7  8  9
>>
>> sapphire:/sys/bus/pci/slots # ls -l 3
>> total 0
>> -r--r--r-- 1 root root 65536 Aug 18 14:10 address
>> lrwxrwxrwx 1 root root     0 Aug 18 14:10 device -> ../../../../devices/pci0000:23/0000:23:01.0
>> lrwxrwxrwx 1 root root     0 Aug 18 14:10 function0 -> ../../../../devices/pci0000:23/0000:23:01.0
>> lrwxrwxrwx 1 root root     0 Aug 18 14:10 function1 -> ../../../../devices/pci0000:23/0000:23:01.1
>
> What's the point with "device" and "function0"?  They appear to be the  
> same thing by definition.

Good point, I'll remove 'device'.

Thanks.

/ac

