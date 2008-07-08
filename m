Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbYGHRg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbYGHRg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYGHRgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 13:36:06 -0400
Received: from bruhost-2.ispvds.com ([82.146.33.243]:58243 "EHLO
	bruhost-2.ispvds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbYGHRgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 13:36:04 -0400
Message-ID: <4873A564.4070103@r000n.net>
Date: Tue, 08 Jul 2008 21:35:32 +0400
From: Roman Mindalev <lists@r000n.net>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: kernel-testers@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: System hangs on 2.6.26-rc8
References: <48637DCC.3070301@r000n.net> <200807021625.05721.rjw@sisk.pl> <486CD31F.3020303@r000n.net> <200807041730.32192.rjw@sisk.pl> <487210DF.7010801@r000n.net>
In-Reply-To: <487210DF.7010801@r000n.net>
Content-Type: multipart/mixed;
 boundary="------------040400030501050302010508"
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (bruhost-2.ispvds.com [82.146.33.243]); Tue, 08 Jul 2008 19:35:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040400030501050302010508
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Roman Mindalev wrote:
> Rafael J. Wysocki wrote:
>> On Thursday, 3 of July 2008, Roman Mindalev wrote:
>>> Rafael J. Wysocki wrote:
>>>> On Thursday, 26 of June 2008, Roman Mindalev wrote:
>>>>> I walking in web with Firefox when my system began freezing.
>>>>> 1. After pressing "KMenu" menu not showing
>>>>> 2. Yakuake's terminals not usable: when I try typing "dmesg | tail" or
>>>>> even "ls" system not answering. I can typing anything (including
>>>>> pressing Ctrl+C or Ctrl+Z), but reaction = 0
>>>>> 3. Consoles (Alt + F1 and other) not usable too. I can't even log-in -
>>>>> after typing username and pressing "Enter" password field not available,
>>>>> and I can typing any text like:
>>>>> ----------------------
>>>>> login: r000n
>>>>> grt
>>>>> rthtr
>>>>> y
>>>>> trht
>>>>> ----------------------
>>>>> 4. Switching back to to X from text console not works: I see only black
>>>>> screen
>>>>> 5. Ctrl + Alt + Del not works, I can restart system only with hardware Reset
>>>>>
>>>>> These strange things was 2 times for last day.
>>>>> Logs empty, last strings from syslog:
>>>>> ------- 1-st time --------------------
>>>>> Jun 26 10:37:16 desktop smartd[4967]: Device: /dev/sdb, SMART Usage
>>>>> Attribute: 190 Airflow_Temperature_Cel changed from 59 to 58
>>>>> Jun 26 10:37:16 desktop smartd[4967]: Device: /dev/sdb, SMART Usage
>>>>> Attribute: 194 Temperature_Celsius changed from 115 to 112
>>>>> Jun 26 10:39:01 desktop /USR/SBIN/CRON[14210]: (root) CMD (  [ -x
>>>>> /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find
>>>>> /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -print0 |
>>>>> xargs -n 200 -r -0 rm)
>>>>> Jun 26 10:41:43 desktop ntpd[5006]: synchronized to 204.9.136.253, stratum 2
>>>>> Jun 26 10:42:51 desktop ntpd[5006]: synchronized to 89.108.124.4, stratum 2
>>>>> Jun 26 10:49:00 desktop syslogd 1.5.0#5: restart.
>>>>> --------------------------------------
>>>>> ------- 2-st time --------------------
>>>>> Jun 26 14:32:37 desktop ntpd[5002]: synchronized to 212.57.153.17, stratum 2
>>>>> Jun 26 14:39:01 desktop /USR/SBIN/CRON[5624]: (root) CMD (  [ -x
>>>>> /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find
>>>>> /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -print0 |
>>>>> xargs -n 200 -r -0 rm)
>>>>> Jun 26 14:44:36 desktop syslogd 1.5.0#5: restart.
>>>>> Jun 26 14:44:36 desktop kernel: klogd 1.5.0#5, log source = /proc/kmsg
>>>>> started.
>>>>> Jun 26 14:44:36 desktop kernel: /tty/ttyr5'
>>>>> --------------------------------------
>>>>> Firefox 3 from svn, updated ~3 days ago.
>>>>> System - Debian sid (updated yesterday).
>>>>> Kernel - 2.6.26-rc8
>>>>>
>>>>> If need more information, tell me, where I should take it)
>>>> Did anything like that happen to you with any previous kernel versions?
>>>>
>>>> Rafael
>>>>
>>> No. 2.6.26-rcX was very clear line for me.
>>> But 2.6.26-rc8 - first kernel, which I compiled with timer 300 Hz
>>> (instead 250). I can compile 2.6.26-rc7 with 300 Hz and 2.6.26-rc8 with
>>> 250 Hz if need.
>>> Frequency of timer almost exclusive thing, which changed in my config
>>> since 2.6.26-rc7
>> Please do that and please do keep the CC list in your replies.
>>
>> For now, we will assume this is a regression from -rc7.
>>
>> Thanks,
>> Rafael
>>
> I can't reproduce it not only with 2.6.26-rc8 (250 Hz), but even with
> 2.6.26.rc8 (300 Hz) - with same kernel and same progs.
> Wine compiling + stress with 10-20 min. timeout + downloading +
> browsing... loadavg up 16, but system works! (Slowly, of course, but works)
> 2.6.26-rc9 (300 Hz) looks also stable.
> It was hardware issue I hope (but not understand, which). If this
> problem appears in the future, I will say about it. Now it seems as
> false regression

A bit more information:
Hangs on
1. package installing (Synaptic), and on
2. recovering of corrupted dpkg database (after hardreset)

Message, listed on screen:
update_menus[6160]: Script /etc/menu-methods/xdg-desktop-entry-spec-apps
received signall 11

With -rc8 and -rc9 I got this SIGSEGV, with -rc7 'dpkg --configure -a'
command was executed without errors

Cut from dpkg log and script attached

--------------040400030501050302010508
Content-Type: text/plain;
 name="dpkg.log-cut"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dpkg.log-cut"

2008-07-07 19:40:14 startup archives unpack
2008-07-07 19:40:42 install pppstatus <none> 0.4.2-10
2008-07-07 19:40:42 status half-installed pppstatus 0.4.2-10
2008-07-07 19:40:42 status triggers-pending man-db 2.5.2-1
2008-07-07 19:40:42 status half-installed pppstatus 0.4.2-10
2008-07-07 19:40:42 status triggers-pending menu 2.1.39
2008-07-07 19:40:42 status half-installed pppstatus 0.4.2-10
2008-07-07 19:40:42 status unpacked pppstatus 0.4.2-10
2008-07-07 19:40:42 status unpacked pppstatus 0.4.2-10
2008-07-07 19:40:42 trigproc man-db 2.5.2-1 2.5.2-1
2008-07-07 19:40:42 status half-configured man-db 2.5.2-1
2008-07-07 19:40:44 status installed man-db 2.5.2-1
2008-07-07 19:40:44 trigproc menu 2.1.39 2.1.39
2008-07-07 19:40:44 status half-configured menu 2.1.39
2008-07-07 19:40:52 status installed menu 2.1.39
2008-07-07 19:40:56 startup packages configure
2008-07-07 19:40:56 configure pppstatus 0.4.2-10 0.4.2-10
2008-07-07 19:40:56 status unpacked pppstatus 0.4.2-10
2008-07-07 19:40:56 status unpacked pppstatus 0.4.2-10
2008-07-07 19:40:56 status unpacked pppstatus 0.4.2-10
2008-07-07 19:40:56 status unpacked pppstatus 0.4.2-10
2008-07-07 19:40:56 status unpacked pppstatus 0.4.2-10
2008-07-07 19:40:56 status unpacked pppstatus 0.4.2-10
2008-07-07 19:40:56 status unpacked pppstatus 0.4.2-10
2008-07-07 19:40:56 status unpacked pppstatus 0.4.2-10
2008-07-07 19:40:56 status half-configured pppstatus 0.4.2-10
2008-07-07 19:40:57 status installed pppstatus 0.4.2-10
2008-07-07 19:40:57 status triggers-pending menu 2.1.39
2008-07-07 19:40:57 status triggers-awaited menu 2.1.39
2008-07-07 19:40:57 trigproc menu 2.1.39 2.1.39
2008-07-07 19:40:57 status half-configured menu 2.1.39
2008-07-07 19:58:33 startup packages configure
2008-07-07 19:58:33 trigproc menu 2.1.39 2.1.39
2008-07-07 19:58:33 status half-configured menu 2.1.39
2008-07-07 20:26:42 startup packages configure
2008-07-07 20:26:42 trigproc menu 2.1.39 2.1.39
2008-07-07 20:26:42 status half-configured menu 2.1.39
2008-07-08 16:41:05 startup packages configure
2008-07-08 16:41:05 configure menu 2.1.39 2.1.39
2008-07-08 16:41:05 status half-configured menu 2.1.39
2008-07-08 16:41:06 status installed menu 2.1.39
2008-07-08 16:41:06 status triggers-pending menu 2.1.39
2008-07-08 16:41:06 status triggers-awaited menu 2.1.39
2008-07-08 16:41:06 trigproc menu 2.1.39 2.1.39
2008-07-08 16:41:06 status half-configured menu 2.1.39
2008-07-08 16:48:27 startup packages configure
2008-07-08 16:48:27 trigproc menu 2.1.39 2.1.39
2008-07-08 16:48:27 status half-configured menu 2.1.39
2008-07-08 20:52:29 startup packages configure
2008-07-08 20:52:29 trigproc menu 2.1.39 2.1.39
2008-07-08 20:52:29 status half-configured menu 2.1.39
2008-07-08 20:54:59 startup packages configure
2008-07-08 20:54:59 trigproc menu 2.1.39 2.1.39
2008-07-08 20:54:59 status half-configured menu 2.1.39
2008-07-08 20:55:05 status installed menu 2.1.39

--------------040400030501050302010508
Content-Type: text/plain;
 name="xdg-desktop-entry-spec-apps"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xdg-desktop-entry-spec-apps"

#!/usr/bin/install-menu
# xdg desktop entry spec - applications generation
# http://www.freedesktop.org/Standards/desktop-entry-spec
# Copyright 2004 - Chris Cheney
# Licensed under the GNU General Public License, version 2.

!include menu.h

compat="menu-2"
outputencoding="UTF-8";
outputlanguage="C";

function AppEntry($terminal) =
	"[Desktop Entry]\n"
	"Type=Application\n"
	"Encoding=UTF-8\n"
	"Name=" title() "\n"
	"GenericName=" $generictitle "\n"
	"Comment=" ifnempty($longtitle,$longtitle) "\n"
	"Icon=" icon() "\n"
	"Exec=" $command "\n"
	"Terminal=" $terminal "\n"
	"Categories=X-Debian" replacewith($basesection,"/ ","--") ";\n";


supported;
 x11 = AppEntry("false");
 text = AppEntry("true");
endsupported;

startmenu = "";
endmenu = "";
submenutitle = "";

treewalk = "M";

genmenu = ifnempty($command,"X-Debian" replacewith($basesection,"/ ","--") "-" tolower(replacewith($title,"/ ","__") ".desktop"));

rootsection = "";

prerun     = "rm -rf  '" prefix() "'";

removemenu = "rm -rf  '" prefix() "'";

preoutput = "";

rootprefix = "/var/lib/menu-xdg/applications/menu-xdg";

userprefix = ".local/share/applications/menu-xdg";

--------------040400030501050302010508--
