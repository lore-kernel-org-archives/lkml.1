Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbYICQ2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbYICQ2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYICQ2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:28:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYICQ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:28:07 -0400
Message-ID: <48BEBAF0.7070008@zytor.com>
Date: Wed, 03 Sep 2008 09:27:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org> <48BD9F36.8000704@zytor.com> <48BE0EDB.20107@kernel.org> <48BEB759.4050503@zytor.com> <48BEB98C.8030303@kernel.org>
In-Reply-To: <48BEB98C.8030303@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> H. Peter Anvin wrote:
>> But just allocating a big bucket of device numbers and throw it all into
>> a pot semirandomly is likely to cause more damage, not less.
> 
> To use ext devt, the system has to use udev for device numbers.  As long
> as udev is used, the major number doesn't matter.

I'm sorry, but that's simply false.  There is a *lot* of code out there 
that assumes you can determine what the device is by correlating the 
major number with /proc/devices.

	-hpa
