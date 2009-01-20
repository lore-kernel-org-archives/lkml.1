Return-Path: <linux-kernel-owner+w=401wt.eu-S1762166AbZATUzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762166AbZATUzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbZATUy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:54:58 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:37803 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756957AbZATUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:54:57 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: STR/STD OK with -rc2 + selected pending patches (was: [git patches] libata hibernation fixes)
Date: Tue, 20 Jan 2009 21:54:51 +0100
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20081104062734.GA4420@havoc.gtf.org> <200901182125.04060.rjw@sisk.pl> <200901182159.13329.elendil@planet.nl> <200901182159.13329.elendil@planet.nl> <200901182352.10036.rjw@sisk.pl>
In-reply-To: <200901182352.10036.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901202154.52506.elendil@planet.nl>
X-OriginalArrivalTime: 20 Jan 2009 20:54:53.0667 (UTC) FILETIME=[58065330:01C97B41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a FYI; most CCs dropped.

Rafael J. Wysocki wrote:
> On Sunday 18 January 2009, Frans Pop wrote:
>> P.S. .29-rc2 is failing both STR and STD on my HP 2510p :-(
>>      Will mail details sometime this week.
> 
> There are some known problems, so please watch the next report of recent
> regressions (most probably tomorrow).

I've been testing -rc2 today with the following patches on top:
* hp-wmi: fix regressions caused by missing if statement
* double disk spin off fix:
  Hibernation: Introduce system_entering_hibernation
  DMI: Introduce dmi_first_match to make the interface more flexible
  SATA: Blacklisting of systems that spin off disks during ACPI power off
  SATA AHCI: Blacklist system that spins off disks during ACPI power off
  SATA Sil: Blacklist system that spins off disks during ACPI power off
  SATA PIIX: Blacklist system that spins off disks during ACPI power off
* selected patches based on regression overview:
  USB: Fix suspend-resume of PCI USB controllers
  Revert "x86: signal: change type of paramter for sys_rt_sigreturn()"
  USB: don't enable wakeup by default for PCI host controllers
  work_on_cpu: dont try to get_online_cpus() in work_on_cpu.

With that both STR and STD work fine and -rc2 looks pretty good in general 
for me. Most "restoring config space" now happens early on resume from 
STR, as intended.

One issue so far (fan keeps running), which I'll report separately in 
bugzilla.

Cheers,
FJP
