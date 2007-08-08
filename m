Return-Path: <linux-kernel-owner+w=401wt.eu-S934432AbXHHEwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432AbXHHEwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 00:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXHHEwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 00:52:37 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:51673 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbXHHEwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 00:52:36 -0400
Message-ID: <46B94C12.2000301@lwfinger.net>
Date: Tue, 07 Aug 2007 23:52:34 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Error message from device_rename in drivers/base/core.c
References: <46B943D3.9020207@lwfinger.net> <20070807.213724.27783161.davem@davemloft.net>
In-Reply-To: <20070807.213724.27783161.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Larry Finger <Larry.Finger@lwfinger.net>
> Date: Tue, 07 Aug 2007 23:17:23 -0500
> 
>> I am getting the following error message from drivers/base/core.c:
>>
>> net eth1: device_rename: sysfs_create_symlink failed (-17)
>>
>> Upon investigation, the call generating the error is renaming 'eth1' to 'eth1'. The following patch 
>> suppresses the error.
> 
> I think this check belongs in udev not in the kernel.  Thankfully
> this message at least tells us it is happening, please don't
> remove it.
> 
> I'm pretty sure it's UDEV doing this, and it should not try to rename
> a netdevice to what it already is named.
> 

Yes, it is most likely coming from udev. Do you know who maintains udev? Google didn't give an 
answer in the first two pages.

Thanks,

Larry

