Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYATWGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYATWGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 17:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYATWG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 17:06:26 -0500
Received: from mail.syneticon.net ([213.239.212.131]:48013 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbYATWGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 17:06:25 -0500
Message-ID: <4793C5CA.5060100@wpkg.org>
Date: Sun, 20 Jan 2008 23:06:02 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Celeron Core
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Clock throttling is not likely to save your battery, unless you have 
>> tasks that are running at 100% CPU for an unlimited time or something, 
>> and you force your CPU to throttle. Normally most people have tasks that 
>> run and then the CPU idles - loading an email, displaying a web page, 
>> etc. Clock throttling will just make these tasks utilize the CPU for a 
>> longer time proportional to the amount clock throttling and therefore 
>> negate any gains in battery usage.

Aren't you forgetting about CPUfreq governors? Which mean: use the 
maximum CPU frequency when the system is busy, throttle down (or lower 
voltage) when the system is idle.

So yes, throttling will save the battery.

Besides, not all CPUs support power management (voltage control).


> IMO clock throttling (as opposed to the reduction of the frequency of an idle
> CPU) is only useful for preventing the CPU from overheating.

And for reducing power on CPUs that can't do any power management, just 
throttling.

For example, a server that doesn't crunch any numbers at night will 
certainly use less power when throttled.


-- 
Tomasz Chmielewski
http://wpkg.org


