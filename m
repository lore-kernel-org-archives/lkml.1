Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZJAS2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZJAS2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZJAS2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:28:50 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:44845 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbZJAS2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:28:50 -0400
Message-ID: <4AC4F4E0.7050404@natemccallum.com>
Date: Thu, 01 Oct 2009 14:28:48 -0400
From: Nathaniel McCallum <nathaniel@natemccallum.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: Exposing device ids and driver names
References: <4AC4DB65.8070404@natemccallum.com> <4AC4EB2E.4050907@s5r6.in-berlin.de> <4AC4EEB2.8090904@natemccallum.com> <4AC4F3B0.6080202@s5r6.in-berlin.de>
In-Reply-To: <4AC4F3B0.6080202@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 02:23 PM, Stefan Richter wrote:
> Nathaniel McCallum wrote:
>> On 10/01/2009 01:47 PM, Stefan Richter wrote:
>>> Nathaniel McCallum wrote:
> [...]
>>>> The second tool, related to the first, is a program which runs on
>>>> Windows and scans for a user's hardware and tells them which distro will
>>>> best support their hardware.
> [...]
>>> Hardware support also depends on userland:  Udev rules, libraries,
>>> application programs.
>>>
>>> Even if you ignore that for now and only look at the kernel part of
>>> hardware support:  Beyond "doesn't have a matching driver" and "does
>>> have", there is a large and impossible to track grey area of "has a
>>> poorly working driver" and "has a perfectly working driver".
>
> There are even more factors for how well something works or even whether
> it works at all:  It may even depend on combinations of two pieces of
> hardware, e.g. bus adapter and device on that bus.  It may depend on
> device firmware revisions.
>
>> Yes, I'm aware of this and will account for it as best as I am able.
> [...]
>> you are correct that we cannot predict 100% of user
>> experience.  But 70% is a huge improvement over 0%.
>
> So, this 2nd tool can't literally say which distribution supports a
> device best.  It can mostly just list which distributions contain a
> matching kernel driver.

I never said that.  What I said is that I will "do my best." This will 
include using other data sources, such as Xorg drivers, libusb drivers, 
user feedback, etc.

Nathaniel
