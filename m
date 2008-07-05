Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYGEIbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYGEIbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 04:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbYGEIbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 04:31:17 -0400
Received: from lucidpixels.com ([75.144.35.66]:45702 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbYGEIbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 04:31:16 -0400
Date: Sat, 5 Jul 2008 04:31:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Setting system clock... (FREEZE) (2.6.25.5)
In-Reply-To: <alpine.DEB.1.10.0806100425570.28343@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0807050430210.14834@p34.internal.lan>
References: <alpine.DEB.1.10.0806100425570.28343@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Jun 2008, Justin Piszcz wrote:

> http://www.linuxquestions.org/questions/linux-general-1/hard-freeze-on-boot-between-setting-clock-and-host-name-625494/
>
> Setting system clock... (FREEZE)
>
> Then, I power cycle the host and it comes up OK, per the above will disable 
> network console support and stop using it, hopefully this solves the problem.
>
> I am not using it elsewhere and have not seen this issue.
>
> At the moment, using: 2.6.25.5 (Debian Testing)
>
> Going to 2.6.25.6 w/network logging disabled.
>
> Was curious though if anyone on the list has seen something similar to this 
> and can confirm if it is indeed the network console logging?
>
> Thanks,
>
> Justin.
>

Apparently it affects other HW platforms as well:
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/8375

I will try using acpi=off/etc in the future to see if it resolves the 
issue, but being so wide-spread could this be a kernel issue since it 
affects many HW types or are there many BIOS implementations that are 
really buggy?

Justin.
