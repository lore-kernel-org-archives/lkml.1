Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYAHGwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYAHGwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 01:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYAHGwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 01:52:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYAHGwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 01:52:21 -0500
Message-ID: <47831D97.7040908@zytor.com>
Date: Mon, 07 Jan 2008 22:52:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Oeser <ioe-lkml@rameria.de>
CC: Andi Kleen <andi@firstfloor.org>, Bernd Schubert <bernd-schubert@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: sleep before boot panic
References: <200801061908.43010.bernd-schubert@gmx.de> <p731w8ts70k.fsf@bingen.suse.de> <200801080717.03467.ioe-lkml@rameria.de>
In-Reply-To: <200801080717.03467.ioe-lkml@rameria.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Oeser wrote:
> On Monday 07 January 2008, Andi Kleen wrote:
>> Bernd Schubert <bernd-schubert@gmx.de> writes:
>>
>>> Hi,
>>>
>>> I just switched to libata (pata) on my laptop and the immediate panic made it 
>>> impossible to figure out why my boot partition wasn't available.
>>> After applying this little patch I could check boot printk output and then saw 
>>> everything was properly recognized and only scsi-disk support was missing.
>> The correct fix would be to make scroll back (and sysrq) still work
>> after panic.  It's a little more complicated, but possible (essentially
>> it needs a polled keyboard handler)
> 
> Customer: "This system could not find the root fs."
> Support: "Oh, yeah, just connect a (USB-) keyboard and scroll back."
> 
> Hmm, device detection works after panic?
> 
> I really like the "soft" panic better, where you still can operate the 
> kernel debugging features, but just have no user space supporting it.
> 

Of course, if we'd been using kinit, "soft panic" would have been done 
exclusively in userspace...

	-hpa
