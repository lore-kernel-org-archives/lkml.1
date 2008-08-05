Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYHED5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYHED5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYHED5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:57:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:37511 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYHED5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:57:13 -0400
Date: Mon, 4 Aug 2008 20:54:50 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Russ Anderson <rja@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>
Subject: Re: x86 BIOS interface for partitioning and system serial number
	on SGI UV
Message-ID: <20080805035450.GA11810@kroah.com>
References: <20080731195753.GB25715@sgi.com> <48934926.2010200@zytor.com> <20080804221951.GA252105@sgi.com> <4897A5FE.9070703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4897A5FE.9070703@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 05:59:42PM -0700, H. Peter Anvin wrote:
> Russ Anderson wrote:
>>> This really seems more that it should belong in sysfs -- 
>>> /sys/class/firmware presumably.
>> /proc/sgi_uv already exists, similar to /proc/sgi_sn on Itanium systems.
>> Would it be /sys/class/firmware?  Reading Documentation/sysfs-rules.txt
>> seems to indicate somewhere under /sys/devices, such as 
>> /sys/devices/system/,
>> but I may be wrong.
>
> /sys/class/firmware is usually where firmware-related things end up, but 
> gregkh is the authority on sysfs organization.

/sys/class/firmware has a few users, but perhaps you are thinking of
/sys/firmware instead?  That's probably the better place for something
that is not using the firmware class itself.

thanks,

greg k-h
