Return-Path: <linux-kernel-owner+w=401wt.eu-S1161082AbXBAFpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161082AbXBAFpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 00:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161149AbXBAFpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 00:45:33 -0500
Received: from terminus.zytor.com ([192.83.249.54]:34024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161082AbXBAFpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 00:45:32 -0500
Message-ID: <45C17E4C.1030509@zytor.com>
Date: Wed, 31 Jan 2007 21:44:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: =?ISO-8859-1?Q?=22S=2E=C3a=C4lar_Onur=22?= <caglar@pardus.org.tr>,
       lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Mark Huang <mlhuang@CS.Princeton.EDU>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Linux 2.6.20-rc7
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <200702010416.59469.caglar@pardus.org.tr> <Pine.LNX.4.64.0701311828540.3632@woody.linux-foundation.org> <200702010501.20994.caglar@pardus.org.tr> <Pine.LNX.4.64.0701311921090.3632@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701311921090.3632@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 1 Feb 2007, S.ÃaÄlar Onur wrote:
>> I think i found the cause of the problem, initramfs can't handle hardlinks 
>> anymore (which works with 2.6.18), copying same /sbin/busybox binary with 
>> different names into initramfs (which ends ups with 50 MB image) or using 
>> symbolic ones instead of hards seems works.
> 
> Ok, it would still be interesting to hear what triggered this.
> 

It would be interesting to know what the inode numbers are in the image; 
also, what is the exact behaviour -- do you end up with a missing link, 
or do both entries end up getting hard-linked to an empty file?

	-hpa

