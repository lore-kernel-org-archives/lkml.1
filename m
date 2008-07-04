Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbYGDP3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbYGDP3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 11:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYGDP2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 11:28:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48164 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbYGDP2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 11:28:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Roman Mindalev <lists@r000n.net>
Subject: Re: System hangs on 2.6.26-rc8
Date: Fri, 4 Jul 2008 17:30:31 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel-testers@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <48637DCC.3070301@r000n.net> <200807021625.05721.rjw@sisk.pl> <486CD31F.3020303@r000n.net>
In-Reply-To: <486CD31F.3020303@r000n.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807041730.32192.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of July 2008, Roman Mindalev wrote:
> Rafael J. Wysocki wrote:
> > On Thursday, 26 of June 2008, Roman Mindalev wrote:
> >> I walking in web with Firefox when my system began freezing.
> >> 1. After pressing "KMenu" menu not showing
> >> 2. Yakuake's terminals not usable: when I try typing "dmesg | tail" or
> >> even "ls" system not answering. I can typing anything (including
> >> pressing Ctrl+C or Ctrl+Z), but reaction = 0
> >> 3. Consoles (Alt + F1 and other) not usable too. I can't even log-in -
> >> after typing username and pressing "Enter" password field not available,
> >> and I can typing any text like:
> >> ----------------------
> >> login: r000n
> >> grt
> >> rthtr
> >> y
> >> trht
> >> ----------------------
> >> 4. Switching back to to X from text console not works: I see only black
> >> screen
> >> 5. Ctrl + Alt + Del not works, I can restart system only with hardware Reset
> >>
> >> These strange things was 2 times for last day.
> >> Logs empty, last strings from syslog:
> >> ------- 1-st time --------------------
> >> Jun 26 10:37:16 desktop smartd[4967]: Device: /dev/sdb, SMART Usage
> >> Attribute: 190 Airflow_Temperature_Cel changed from 59 to 58
> >> Jun 26 10:37:16 desktop smartd[4967]: Device: /dev/sdb, SMART Usage
> >> Attribute: 194 Temperature_Celsius changed from 115 to 112
> >> Jun 26 10:39:01 desktop /USR/SBIN/CRON[14210]: (root) CMD (  [ -x
> >> /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find
> >> /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -print0 |
> >> xargs -n 200 -r -0 rm)
> >> Jun 26 10:41:43 desktop ntpd[5006]: synchronized to 204.9.136.253, stratum 2
> >> Jun 26 10:42:51 desktop ntpd[5006]: synchronized to 89.108.124.4, stratum 2
> >> Jun 26 10:49:00 desktop syslogd 1.5.0#5: restart.
> >> --------------------------------------
> >> ------- 2-st time --------------------
> >> Jun 26 14:32:37 desktop ntpd[5002]: synchronized to 212.57.153.17, stratum 2
> >> Jun 26 14:39:01 desktop /USR/SBIN/CRON[5624]: (root) CMD (  [ -x
> >> /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find
> >> /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -print0 |
> >> xargs -n 200 -r -0 rm)
> >> Jun 26 14:44:36 desktop syslogd 1.5.0#5: restart.
> >> Jun 26 14:44:36 desktop kernel: klogd 1.5.0#5, log source = /proc/kmsg
> >> started.
> >> Jun 26 14:44:36 desktop kernel: /tty/ttyr5'
> >> --------------------------------------
> >> Firefox 3 from svn, updated ~3 days ago.
> >> System - Debian sid (updated yesterday).
> >> Kernel - 2.6.26-rc8
> >>
> >> If need more information, tell me, where I should take it)
> > 
> > Did anything like that happen to you with any previous kernel versions?
> > 
> > Rafael
> > 
> No. 2.6.26-rcX was very clear line for me.
> But 2.6.26-rc8 - first kernel, which I compiled with timer 300 Hz
> (instead 250). I can compile 2.6.26-rc7 with 300 Hz and 2.6.26-rc8 with
> 250 Hz if need.
> Frequency of timer almost exclusive thing, which changed in my config
> since 2.6.26-rc7

Please do that and please do keep the CC list in your replies.

For now, we will assume this is a regression from -rc7.

Thanks,
Rafael
