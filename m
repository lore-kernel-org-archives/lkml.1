Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZCAPJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZCAPJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 10:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbZCAPJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 10:09:09 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:49474 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZCAPJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 10:09:09 -0500
Message-ID: <49AAA50F.5070209@krogh.cc>
Date: Sun, 01 Mar 2009 16:09:03 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain> <49A6F39F.9040801@krogh.cc>
In-Reply-To: <49A6F39F.9040801@krogh.cc>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Krogh wrote:
> The "current_clocsource" is the same on both systems.
> 
> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> tsc

What selects the "current_clocksource"? I tried to boot one of the 
kernels hat have the problem on another piece of hardware and on that 
system it ended up defaulting to "acpi_pm" instead of "tsc".

http://krogh.cc/~jesper/dmesg-2.6.28.7.txt

"acpi_pm" seems to be reliable all the time.

-- 
Jesper
