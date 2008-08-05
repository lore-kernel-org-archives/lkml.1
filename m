Return-Path: <linux-kernel-owner+w=401wt.eu-S1763556AbYHEBG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763556AbYHEBG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 21:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759607AbYHEBAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 21:00:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41942 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759369AbYHEA77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:59:59 -0400
Message-ID: <4897A5FE.9070703@zytor.com>
Date: Mon, 04 Aug 2008 17:59:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>, Greg KH <greg@kroah.com>
Subject: Re: x86 BIOS interface for partitioning and system serial number
 on SGI UV
References: <20080731195753.GB25715@sgi.com> <48934926.2010200@zytor.com> <20080804221951.GA252105@sgi.com>
In-Reply-To: <20080804221951.GA252105@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russ Anderson wrote:
>> This really seems more that it should belong in sysfs -- 
>> /sys/class/firmware presumably.
> 
> /proc/sgi_uv already exists, similar to /proc/sgi_sn on Itanium systems.
> 
> Would it be /sys/class/firmware?  Reading Documentation/sysfs-rules.txt
> seems to indicate somewhere under /sys/devices, such as /sys/devices/system/,
> but I may be wrong.

/sys/class/firmware is usually where firmware-related things end up, but 
gregkh is the authority on sysfs organization.

	-hpa
