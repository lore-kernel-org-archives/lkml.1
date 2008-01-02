Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbYABSPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbYABSPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYABSPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:15:32 -0500
Received: from mail.tmr.com ([64.65.253.246]:34261 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbYABSPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:15:31 -0500
Message-ID: <477BD9DA.8030403@tmr.com>
Date: Wed, 02 Jan 2008 13:37:14 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: semi-regular plea for stable device mapping
References: <200801011054.40512.gene.heskett@gmail.com> <Pine.LNX.4.64.0801011723140.14900@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801011723140.14900@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jan 1 2008 10:54, Gene Heskett wrote:
>> BUT!  This defeats a fix I've had in my modprobe.conf for over a year now that 
>> gave the LVM stuff a stable major device # of 238, and now my LVM major is 
>> back to whatever mood the kernel is in, in this particular bootup case to 
>> #253.
>>
>> It may now be stable for a bit at that number because I see that pktcdvd has 
>> been given a stable address of its own, apparently with a major of 10.  That 
>> was the wedgie that fscked things up originally for me.  But what else lurks 
>> in the deep end of this experimental pool, to play piranna with us again when 
>> we least expect it?
> 
> Why exactly would you require a fixed major - not running udev or thelike?
> Use the boot parameter, dm_mod.major=238.
> 
What? And what happens when that gets used for something else? And if 
you say "we'll avoid using that" then you are treating it as a fixed 
value anyway.

>> This drives tar up a wall because it uses this device number as part of the 
>> file comparisons it does, and it thinks everything is therefore new and needs 
>> a full level 0 backup.  This is not at all practical, and requires that 
> 
> I wonder how FreeBSD gets around this, because they've got dynamic numbers
> everywhere.

Did they? I haven't tried using tar in the appropriate ways on BSD to 
see if it behaves in the same way. Of course on a system which doesn't 
change between backups I guess the dynamic number would be the same in 
any case.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
