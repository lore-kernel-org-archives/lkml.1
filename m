Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257Ab0AVWuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0AVWuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 17:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176Ab0AVWuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 17:50:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43423 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab0AVWuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 17:50:07 -0500
Message-ID: <4B5A2B80.8040904@zytor.com>
Date: Fri, 22 Jan 2010 14:49:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com,
       vojtech@suse.cz
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
References: <1264011793.1735.3683.camel@localhost.localdomain>	 <4B57A2D4.9030204@gmail.com>	 <20100121185544.GB11996@core.coreip.homeip.net>	 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>	 <20100121221701.GA15293@core.coreip.homeip.net>	 <51f3faa71001211626y1e65f81ambfa4ad19af5aa5ff@mail.gmail.com>	 <4B59E47D.8010702@zytor.com> <51f3faa71001221433k72f20addg48e0735fe1b032d@mail.gmail.com>
In-Reply-To: <51f3faa71001221433k72f20addg48e0735fe1b032d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2010 02:33 PM, Robert Hancock wrote:
>>
>> You think it's reasonable to have the keyboard not work because
>> someone's KVM switch was in the wrong position when the system booted?
>> Sorry, that's not how the world works.  It's sad that someone had the
>> bright idea that things should work that way, but that is definitely a
>> regression I wouldn't want to deal with.
> 
> I don't imagine most KVM switches would result in this - they usually
> emulate the presence of a keyboard and mouse on all ports even if the
> input isn't the active one. It could be the reporter had an older
> switch that didn't do this.
> 

The good ones do.  The bad (cheap) ones just provide for a basic
electric disconnect.  Heck, there used to be mechanical KVMs...

> I expect that it's quite common for the BIOS to disable the controller
> if no device is detected, though. I think the idea is to prevent a
> useless device from showing up in Device Manager and free up resources
> for other devices. Problem is if it does this, we don't really know
> what it did other than remove the PNP entry, and whether using the
> controller anyway will work safely.
> 
> In any case, it's unlikely (though I admit I'm uncertain) that Windows
> is going to blindly probe for an 8042 controller if the PNP
> information doesn't indicate that one should be there - at least not
> if it's using the ACPI HAL. And for this sort of hardware
> compatibility issue, doing things differently than Windows does is
> ultimately asking for trouble in the long term. It's highly
> unreasonable to break that just for an unlikely corner case.

It's not unlikely - it's reality.  Furthermore, BIOS programmers do
weird things all the time, especially to support, say, old Windows
versions that noone cares about anymore but mattered then.

	-hpa
