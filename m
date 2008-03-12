Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbYCLTJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbYCLTJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYCLTJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:09:10 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:35389 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751756AbYCLTJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:09:09 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2008 15:09:09 EDT
Message-ID: <47D828BB.2000702@gawab.com>
Date: Wed, 12 Mar 2008 12:02:19 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not sure, but I think I've found a regression in the latest development kernel (2.6.25-rc5).
The problems don't happen when using the distro's 2.6.22 kernel (ubuntu 7.10), or when I was testing 2.6.23 and 2.6.24.

These are the problems I've been having:

1) Blank screen: Upon entering graphical mode the screen goes blank (black). It seems to happen when X is probing for the video modes.
Pressing ctrl+alt+f1 doesn't do anything, except "refresh" a black screen. The computer still works, and I can log in from GDM,
but I just can't see anything on the screen; I have to reboot.
The work around is that when the boot splash screen (usplash) is about halfway loaded I switch to the first terminal,
and everything is fine (or maybe that's just a coincidence).

2) Wireless errors: Upon connecting to a wireless router I get a flood of kernel messages that don't stop:
"kernel: wlan0_rename: RX too short data frame payload".
I do successfully connect. No workaround to stop the messages (while still having connection).

3) Flashing Red: When I shutdown, the screen flashes red several times before the shutdown splash screen shows up.

#1 and #3 happen at random. Although, It seems to happen more on the first boot up.
#2 consistently happens when connecting to my University's wireless; rarely (if ever) on my home router.

Relevant sysinfo (Dell Inspiron E1505; Intel T2080 @ 1.73GHz):
0b:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)

Could this be a regression? What can I do to help identify the problem?
I've tried to start analyzing the blank screen problem, so let's start there because I've already created a diff log report.

For a diff of my system logs for the blank screen problem see (104.61 KB):
http://jdserver.homelinux.org/linux/blank_screen_log_diff.txt

For full details about my system see (23.14 KB):
http://jdserver.homelinux.org/linux/sysinfo-2.6.25-rc5.txt

For my config file that I used see (40.84 KB):
http://jdserver.homelinux.org/linux/config-2.6.25-rc5

Hopefully this helps and I can get my problems solved.

Thanks

