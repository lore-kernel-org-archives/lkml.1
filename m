Return-Path: <linux-kernel-owner+w=401wt.eu-S934366AbYBNACi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934366AbYBNACi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764516AbYBNAC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:02:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:49754 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763917AbYBNAC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:02:27 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: strange SysRq problem
Date: Thu, 14 Feb 2008 01:02:14 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802140102.14252.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX18IorVc4PmpMV+ypQ1P/NHcipO4MG1FWqDtg59
 5fxid0YyQ95h9fGJPeU+j3YN9n5yk1lIlSgtrLrKjfCoStudGL
 i8xVeAzKaVL/6HLN/7+WQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm suffering from a strange SysRq problem:

syslog shows haphazardly "SysRq : HELP" lines, while I definitely didn't 
triggered them, neither via (PS/2) keyboard, nor via /proc/sysrq-trigger.
This is accompanied with stalls of about 15-60 secs. 

Here's an example:

Feb 14 00:16:11 xrated kernel: SysRq : HELP : loglevel0-8 reBoot Crashdump 
tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw 
Sync showTasks Unmount shoW-blocked-tasks 
Feb 14 00:32:45 xrated kernel: SysRq : HELP : loglevel0-8 reBoot Crashdump 
tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw 
Sync showTasks Unmount shoW-blocked-tasks 
Feb 14 00:32:57 xrated kernel: SysRq : HELP : loglevel0-8 reBoot Crashdump 
tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw 
Sync showTasks Unmount shoW-blocked-tasks 
Feb 14 00:32:57 xrated kernel: SysRq : HELP : loglevel0-8 reBoot Crashdump 
tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw 
Sync showTasks Unmount shoW-blocked-tasks 
Feb 14 00:33:04 xrated kernel: SysRq : HELP : loglevel0-8 reBoot Crashdump 
tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw 
Sync showTasks Unmount shoW-blocked-tasks 
Feb 14 00:33:24 xrated kernel: SysRq : HELP : loglevel0-8 reBoot Crashdump 
tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw 
Sync showTasks Unmount shoW-blocked-tasks 
Feb 14 00:33:24 xrated kernel: SysRq : HELP : loglevel0-8 reBoot Crashdump 
tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw 
Sync showTasks Unmount shoW-blocked-tasks 
Feb 14 00:33:24 xrated kernel: SysRq : HELP : loglevel0-8 reBoot Crashdump 
tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw 
Sync showTasks Unmount shoW-blocked-tasks 
Feb 14 00:33:24 xrated kernel: SysRq : HELP : loglevel0-8 reBoot Crashdump 
tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw 
Sync showTasks Unmount shoW-blocked-tasks 
Feb 14 00:33:33 xrated kernel: SysRq : HELP : loglevel0-8 reBoot Crashdump 
tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw 
Sync showTasks Unmount shoW-blocked-tasks 

Anybody suffered from similar behavior out there, and tracked it down?

TIA,
Pete
