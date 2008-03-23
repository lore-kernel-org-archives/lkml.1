Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbYCWXdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbYCWXdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 19:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbYCWXde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 19:33:34 -0400
Received: from mail.tmr.com ([64.65.253.246]:47444 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673AbYCWXde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 19:33:34 -0400
Message-ID: <47E6E8B4.5000602@tmr.com>
Date: Sun, 23 Mar 2008 19:33:08 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: axboe@suse.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH][RESEND][v3] Modify loop device to be able to manage 
  partitions of the disk image
References: <12058427603971-git-send-email-Laurent.Vivier@bull.net>	 <47E17673.4040302@tmr.com> <1205958752.4758.13.camel@frecb07144>
In-Reply-To: <1205958752.4758.13.camel@frecb07144>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> Le mercredi 19 mars 2008 à 16:24 -0400, Bill Davidsen a écrit :
>> Laurent Vivier wrote:
>>> v3 is an updated version of v2, replacing a "%d" by a "%lu".
>>>
>>> This patch allows to use loop device with partitionned disk image.
>>>
>> How does this compare in overhead to using nbd?
> 
> What do you mean ?
> 
> NBD doesn't manage partitions... but I also have a patch to do that.
> NBD implies an NBD server and an NBD client in userspace, so loop is
> better when disk image is in a raw format.
> 
Actually the usual partitioning tools will create partitions on nbd 
volumes, but without inodes they are not useful. I thought we used to 
have that working, to work on virtual machine "disk" files which were 
partitioned, but that was several years ago and I could be 
misremembering. I did use fdisk on an nbd device before I asked about 
overhead, but I didn't try to use the partitions.

In any case, if you have code to make nbd partitions work in a currently 
useful way, that might be useful for keeping disk images handy for 
mount. The kvm copy on write might let the fresh install image be shared 
and VMs customize as needed.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

