Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbYAVAAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbYAVAAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 19:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYAVAAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 19:00:12 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:22540 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYAVAAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 19:00:10 -0500
Date: Mon, 21 Jan 2008 17:59:46 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM: Celeron Core
In-reply-to: <fa.tHyDHqRNYFvp4N4SR4JtJRuqh0k@ifi.uio.no>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <479531F2.3010607@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.tHyDHqRNYFvp4N4SR4JtJRuqh0k@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski wrote:
>>> Clock throttling is not likely to save your battery, unless you have 
>>> tasks that are running at 100% CPU for an unlimited time or 
>>> something, and you force your CPU to throttle. Normally most people 
>>> have tasks that run and then the CPU idles - loading an email, 
>>> displaying a web page, etc. Clock throttling will just make these 
>>> tasks utilize the CPU for a longer time proportional to the amount 
>>> clock throttling and therefore negate any gains in battery usage.
> 
> Aren't you forgetting about CPUfreq governors? Which mean: use the 
> maximum CPU frequency when the system is busy, throttle down (or lower 
> voltage) when the system is idle.
> 
> So yes, throttling will save the battery.

We are talking about throttling (i.e. P4 clockmod) not CPU frequency 
scaling. Clock modulation does not reduce the clock speed, it just 
basically forces the CPU to halt on a certain duty cycle. If the CPU is 
already idle this has no effect and won't save any power.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

