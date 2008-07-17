Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbYGQOec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbYGQOec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbYGQOeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:34:23 -0400
Received: from mercury.realtime.net ([205.238.132.86]:50949 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755978AbYGQOeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:34:22 -0400
In-Reply-To: <20080717070759.GE22090@kroah.com>
References: <for-27-patch1-0@bga.com> <for-27-patch9@bga.com> <20080712041137.GA5933@kroah.com> <e6b3109a0ab047bea58ceecb8734761d@bga.com> <0a67ecbf69649dce778db1b463e59c3a@bga.com> <ad61f8387a737bc410e9d6dc3a8a5b63@bga.com> <20080717070759.GE22090@kroah.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <8c10c96094849c022d42a9d7d625e525@bga.com>
Content-Transfer-Encoding: 7bit
Cc: Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>, Greg KH <gregkh@suse.de>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Date: Thu, 17 Jul 2008 09:36:14 -0500
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 17, 2008, at 2:07 AM, Greg KH wrote:

> On Wed, Jul 16, 2008 at 05:18:18AM -0500, Milton Miller wrote:
>>
>> Greg,
>>
>> Please respond to this email and explain why the patch
>>
>> pci: dynids.use_driver_data considered harmful
>>
>> http://www.ussg.iu.edu/hypermail/linux/kernel/0807.1/index.html#2188
>>
>> should not be applied.   I am not arguing the correctness of
>> the removed code, rather its utility and benefit to the linux
>> community.
>>
>> As far as I can tell, the code only succeeds in limiting the
>> usefulness of the pci dynamic id addition mechanism.
...
>
> Sorry, I'm on the road right now and will not get back until Friday.
> Then I have the big merges with Linus to get through.  I'll try to get
> to this by Monday, but my original point still stands, this was
> implemented for a reason, saying that not enough drivers use it 
> properly
> does not make the need for it to go away.  It is required for them, so
> perhaps the other 419 drivers also need to have the flag set.  That's
> pretty trivial to do, right?
>

Fine, I'll give you a little time.  But I want to hear specifics how it
helps drivers.   I have shown how it hurts many drivers.   My arguement
is that once we set the flag on the drivers, we will end up with it set
on all drivers or the remaining drivers will not care.   There were 413+
drivers in linux-next that were compiled by allyesconfig, about 150 used
driver data.

If the purpose is to enforce range checking, then I'll start working on
patches for those 100 drivers to do that.   But I don't see why a binary
flag helps any driver.   The flag is not "I will accept a additional id
table", its "I will accept the additional driver data that I need to
operate" on my dynamically added id table.

milton

