Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYFGVih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYFGVih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYFGVi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:38:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36930 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYFGVi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:38:26 -0400
Date: Sat, 7 Jun 2008 23:39:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: pavel@suse.cz, auke-jan.h.kok@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, len.brown@intel.com,
       cpufreq@lists.linux.org.uk, davej@codemonkey.org.uk
Subject: Re: bug? acpi p-state + ondemand keeps dropping max freq
Message-ID: <20080607213918.GC1746@elf.ucw.cz>
References: <20080606140846.GA9580@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606140846.GA9580@ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I've consistently experienced the following bizarre problem since 2.6.20, all the
> way up to 2.6.25.3 (regressed yesterday and each of these kernels exposes this
> behaviour):
> 
> /sys/devices/system/cpu/cpu0/cpufreq # grep . *
> affected_cpus:0
> cpuinfo_cur_freq:800000
> cpuinfo_max_freq:1866000
> cpuinfo_min_freq:800000
> scaling_available_frequencies:1866000 1600000 1333000 1066000 800000
> scaling_available_governors:ondemand performance
> scaling_cur_freq:800000
> scaling_driver:acpi-cpufreq
> scaling_governor:ondemand
> scaling_max_freq:800000
> scaling_min_freq:800000
> 
> 
> 
> Notice that scaling_mx_freq dropped down to the lowest possible value and as such
> my CPU is only working at 800MHz. At boot time this field properly displays
> 1866MHz and everything works OK. After a certain period (?) this value drops down
> and I cannot manually elevate it back to the normal level:
> 
> # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> 800000
> # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> 800000
> 
> 
> This renders my Dothan to utterly poor speeds. (standard T43)
> 
> performance cpufreq governor makes no difference - I still can't change the
> frequency upper/lower values.

Hmm, I have similar problem in Novell bugzilla, on very different hw:

https://bugzilla.novell.com/show_bug.cgi?id=396311

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
