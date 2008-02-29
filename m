Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYB2FtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYB2FtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYB2Fsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:48:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbYB2Fsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:48:52 -0500
Message-ID: <47C79CB1.6050104@redhat.com>
Date: Fri, 29 Feb 2008 00:48:33 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       sparclinux@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/2] firewire: endianess fix
References: <20080220220326.GA22328@uranus.ravnborg.org>	 <200802272221.38985.jwilson@redhat.com>	 <1204179959.15052.372.camel@pasglop>	 <200802281342.06493.jwilson@redhat.com> <1204241162.15052.393.camel@pasglop>
In-Reply-To: <1204241162.15052.393.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Thu, 2008-02-28 at 13:42 -0500, Jarod Wilson wrote:
>> On Thursday 28 February 2008 01:25:59 am Benjamin Herrenschmidt wrote:
>>>> Under Mac OS X, system.log says "FireWire (OHCI) Apple ID 31 built-in now
>>>> active". Could still be lucent though, judging by the subsys device ID of
>>>> 5811, which matches up w/the Lucent/Agere FW323. But no, apparently I
>>>> don't have the interesting one.
>>> Well, it's interesting in the sense that it's a "normal" OHCI then on a
>>> BE machine :-) My Pismo, which had the weirdo one, unfortunately died a
>>> while ago. I'll see if I can find another machine with that one in.
>> Ah, the pismo has it, eh? I think I may actually know of someone in the office 
>> that still has one of those that I might be able to borrow and poke at...
> 
> I -think- it has it... Pismo definitely has one of the first variant of
> UniNorth with "working" FW afaik.
> 
> The first UniNorth was used in the first "toilet-seat" ibook, but I
> think this one didn't have firewire, or a non-working one... and in the
> first Sawtooth G4 for which FW and Ethernet even were separate PCI chips
> because the ones in UniNorth were too broken.
> 
> It's possible that early G4 titanium powerbooks or other model of FW
> iBooks have that UniNorth FW variant too.

Still no luck finding one here. The person I was thinking of has a 
Lombard, which has no firewire. I did get ahold of a 667MHz Titanium, 
but its got an Agere FW323. Pretty sure my old man actually has a Pismo, 
but its about a 3000 mile drive over to my folks house. The search 
continues... I wonder how many people still actually 1) have a machine 
with this controller, 2) are running Linux on it and 3) use firewire 
devices with it. Both of you, please speak up, we're trying to help you! 
(if only out of morbid curiosity to see this mythical goofy controller).

-- 
Jarod Wilson
jwilson@redhat.com
