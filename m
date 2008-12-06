Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYLFGJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYLFGJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 01:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYLFGJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 01:09:26 -0500
Received: from mailout11.t-online.de ([194.25.134.85]:38337 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYLFGJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 01:09:26 -0500
Message-ID: <493A170C.90509@t-online.de>
Date: Sat, 06 Dec 2008 07:09:16 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27.7 built for Geode: Clock drift
References: <49358017.7080009@t-online.de> <1f1b08da0812051340t1967e753h354346d13ccb34d3@mail.gmail.com>
In-Reply-To: <1f1b08da0812051340t1967e753h354346d13ccb34d3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: rAGltiZQQhlAQRWqF1x2-jb2397hZWFwX-cZ0zoA4t1J2lieY-J41Hqi3tP9nDIZOl
X-TOI-MSGID: 0d5b3bab-6cfb-41b0-a124-ef9b41b4ae80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> 
> For both configs, can you run:
>    cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> and:
>    cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> 
> Then send back the output?
> 

Sure. For 486:

% cat /sys/devices/system/clocksource/clocksource0/available_clocksource
pit jiffies
% cat /sys/devices/system/clocksource/clocksource0/current_clocksource
pit


For Geode (clock is running too fast):
% cat /sys/devices/system/clocksource/clocksource0/available_clocksource
jiffies
% cat /sys/devices/system/clocksource/clocksource0/current_clocksource
jiffies


dmesg says for Geode:

:
TSC: Unable to calibrate against PIT
TSC: No reference (HPET/PMTIMER) available
Marking TSC unstable due to could not calculate TSC khz
:


Regards

Harri

