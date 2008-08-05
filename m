Return-Path: <linux-kernel-owner+w=401wt.eu-S1762514AbYHEAyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762514AbYHEAyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbYHEAvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:51:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44623 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbYHEAvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:51:05 -0400
Message-ID: <4897A3DC.2040803@zytor.com>
Date: Mon, 04 Aug 2008 17:50:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
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
> 
> /proc/sgi_uv already exists, similar to /proc/sgi_sn on Itanium systems.
> 

Both those to be really awful.

> Would it be /sys/class/firmware?  Reading Documentation/sysfs-rules.txt
> seems to indicate somewhere under /sys/devices, such as /sys/devices/system/,
> but I may be wrong.
> 
>>> +# define BIOS_CALL(result, a0, a1, a2, a3, a4, a5, a6, a7)		\
>>> +	do {								\
>>> +		/* XXX - the real call goes here */			\
>>> +		result.status = BIOS_STATUS_UNIMPLEMENTED;		\
>>> +		result.v0 = 0;						\
>>> +		result.v1 = 0;						\
>>> +	} while (0)
>> I have more than a little problem with submitting patches like this.  We 
>> have no way to judge the suitability of the coding or the interface with 
>> the "meat" of the driver stubbed out!
> 
> This is also code for hardware that does not exist.  In order for the
> code to be in distro releases in time for the hardware to ship, we
> must push it _before_ we have hardware.  The main concern is getting in
> interfaces now, because the interfaces cannot change in a minor release.
> Providing more "meat" is on the ToDo list.  

You could still document the intended interface so we know how it is 
supposed to work.  At this point, you're basically saying "trust us", 
which really isn't how the Linux community is supposed to work.

	-hpa
