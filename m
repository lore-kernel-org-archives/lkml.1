Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYLLUXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYLLUXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYLLUXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:23:22 -0500
Received: from lucidpixels.com ([75.144.35.66]:41397 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbYLLUXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:23:21 -0500
Date: Fri, 12 Dec 2008 15:23:19 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Pavel Machek <pavel@suse.cz>
cc: smartmontools-support@lists.sourceforge.net,
       smartmontools-database-owner@lists.sourceforge.net,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Intel X25-E running Linux using XFS
In-Reply-To: <20081212185803.GE11974@elf.ucw.cz>
Message-ID: <alpine.DEB.1.10.0812121516190.17857@p34.internal.lan>
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan> <20081212185803.GE11974@elf.ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Dec 2008, Pavel Machek wrote:

>
> Hi!
>
>> Due to the 100k write cycle lifetime, I will not be performing any more
>> benchmarks on the SSD itself, such benchmarks are available on
>> techreport.com but just wanted to send out the smart data for the
>> smartmontools list and point out it is working with linux+ich7+xfs.
>>
>> Overall, whenever I do anything now its just like the entire machine is
>> sitting in a ramdisk (similar when you boot knoppix and load to ramdisk).
>>
>> The techreport benchmarks are here:
>> http://techreport.com/articles.x/15931
>
> Actually I'd like to know... how does it behave during powerfails
> while it is being written to?
>
> Flashes I seen (USB / SD) developed bad sectors in that case, and
> ext2/ext3 can't handle that. (And I don't think xfs can handle that
> either).

I have a UPS for all of my machines, so that will not be a problem in my 
case.  I do not wish to trash a $720 SSD or my current install, if someone 
else wants to try feel free though :)

With barriers, presumably it would be safe-- but as always, a UPS/and 
barriers and/or RAID, there is no excuse not to have regular backups 
incase of a failure at any time..

I do recall however one instance where there was an apt-get dist-upgrade 
going and the power was cut to a machine on purpose (before/not 
using barriers) and suffice to say-- it got mucked/suffered many corruptions
all over the place.

Justin.
