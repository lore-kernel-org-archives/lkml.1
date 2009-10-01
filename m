Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZJASHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZJASHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbZJASHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:07:41 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:42012 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbZJASHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:07:40 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2009 14:07:40 EDT
Message-ID: <4AC4EEB2.8090904@natemccallum.com>
Date: Thu, 01 Oct 2009 14:02:26 -0400
From: Nathaniel McCallum <nathaniel@natemccallum.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: Exposing device ids and driver names
References: <4AC4DB65.8070404@natemccallum.com> <4AC4EB2E.4050907@s5r6.in-berlin.de>
In-Reply-To: <4AC4EB2E.4050907@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 01:47 PM, Stefan Richter wrote:
> Nathaniel McCallum wrote:
>> Please CC me on any responses as I'm not subscribed to lkml.
>>
>> I have the aim at creating two tools helpful to linux.  The first tool
>> is a driver regression test of sorts.  I want to be able to create
>> essentially a time line of hardware support as they appear in distros.
>> The second tool, related to the first, is a program which runs on
>> Windows and scans for a user's hardware and tells them which distro will
>> best support their hardware.  I already have a working prototype of
>> these two tools.  It currently uses the data exported by modinfo.  This
>> however does not provide transparency for drivers compiled into the kernel.
>
> Hardware support also depends on userland:  Udev rules, libraries,
> application programs.
>
> Even if you ignore that for now and only look at the kernel part of
> hardware support:  Beyond "doesn't have a matching driver" and "does
> have", there is a large and impossible to track grey area of "has a
> poorly working driver" and "has a perfectly working driver".

Yes, I'm aware of this and will account for it as best as I am able. 
There is still tremendous value in identifying (with real data):
1. differences between distros and upstream
2. the flow of driver support between distros and upstream
3. statistically common devices that have no driver

Further, for the most common device classes (video cards, networking, 
wireless, etc) it is fairly easy to get a good reading.  For instance, 
the difference between "no graphics at all" and "some graphics" is 
infinitely larger than "some graphics" and "great 3D acceleration."  I'm 
not aware of any video cards which have drivers that claim to support 
them that can't at least modeset.

To summarize, you are correct that we cannot predict 100% of user 
experience.  But 70% is a huge improvement over 0%.

Nathaniel
