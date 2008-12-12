Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbYLLHmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbYLLHmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 02:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbYLLHmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 02:42:09 -0500
Received: from smtpn2.emerion.com ([212.69.178.34]:36264 "EHLO
	smtps02.emerion.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750719AbYLLHmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 02:42:08 -0500
From: Philipp Marek <philipp.marek@emerion.com>
Organization: Emerion.com
To: linux-kernel@vger.kernel.org
Subject: acpi_cpufreq/cpufreq_stats: "warning: sysfs group ... not found"
Date: Fri, 12 Dec 2008 08:42:03 +0100
User-Agent: KMail/1.10.1 (Linux/2.6.26-1-amd64; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812120842.04479.philipp.marek@emerion.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody!

My notebook is using acpi_cpufreq and cpufreq_stats, with 2.6.27.6, but the 
same happened for 2.6.26 (and IIRC 2.6.25 and earlier).

I have a script that uses the /sys/ files to show some information.
If I "rmmod acpi_cpufreq" and "modprobe acpi_cpufreq", followed by "rmmod 
cpufreq_stats" (because there's no directory "stats" below /sys/.../cpufreq), 
I get this warning.


The calltrace shows
	...
	? mutex_unlock
	cpufreq_stats_free_table+0x54
	cpufreq_stats_exit+0x45
	sys_delete_module
	...


Regards,

Phil

