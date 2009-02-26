Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbZBZUnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbZBZUnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZBZUn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:43:26 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:35231 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbZBZUnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:43:25 -0500
Message-ID: <49A6FEE2.90700@krogh.cc>
Date: Thu, 26 Feb 2009 21:43:14 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain> <49A6F39F.9040801@krogh.cc> <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 26 Feb 2009, Jesper Krogh wrote:
>> 2.6.26.8 doesnt have this problem.
>>
>> The "current_clocsource" is the same on both systems.
>>
>> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>> tsc
> 
> What does the frequency calibrate to? It should be in the dmesg. Does it 
> differ by a big amount?

Non-working:
$ dmesg | grep -i freq
[    0.004007] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 4620.05 BogoMIPS (lpj=9240104)

2.6.26.8 doesn't have that information.

-- 
Jesper

