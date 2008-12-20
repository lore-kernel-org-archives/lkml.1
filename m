Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYLTGKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYLTGKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 01:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYLTGKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 01:10:07 -0500
Received: from main.gmane.org ([80.91.229.2]:34811 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYLTGKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 01:10:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Problem with thermal control: ACPI: Critical trip point - Critical
   temperature reached  - shutting down.
Date: Sat, 20 Dec 2008 00:06:19 -0600
Message-ID: <494C8B5B.8020606@shaw.ca>
References: <gigib1$fbj$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <gigib1$fbj$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Bono wrote:
> Hi all
> 
> My notebook shutdown down with intensive cpu load
> In log I found this type of messages 
> 
> 
> Dec 19 16:10:08 champagne kernel: ACPI: Critical trip point
> Dec 19 16:10:08 champagne kernel: Critical temperature reached (105 C), 
> shutting down.
> Dec 19 16:10:08 champagne kernel: ACPI: Critical trip point
> Dec 19 16:10:08 champagne kernel: Critical temperature reached (105 C), 
> shutting down.
> Dec 19 16:10:08 champagne kernel: ACPI: Critical trip point
> Dec 19 16:10:08 champagne kernel: Critical temperature reached (105 C), 
> shutting down.
> Dec 19 16:10:08 champagne kernel: ACPI: Critical trip point
> Dec 19 16:10:08 champagne kernel: Critical temperature reached (105 C), 
> shutting down.
> Dec 19 16:10:16 champagne kernel: Critical temperature reached (87 C), 
> shutting down.
> 
> Simply I can't do a "make -j2" to compile a kernel
> First time of this behaviour appear with 2.6.27 but maybe I didn't stress 
> enough my system
> Notebook is an hp 8510p, some log and information below
> 
> Any idea?
> 
> thanks
> 
> 
> cat /proc/acpi/thermal_zone/*/*
> <setting not supported>
> <polling disabled>
> state:                   active[0]
> temperature:             85 C
> critical (S5):           256 C
> passive:                 100 C: tc1=1 tc2=2 tsp=300 devices=CPU0 CPU1
> active[0]:               85 C: devices=C387
> active[1]:               65 C: devices=C388
> active[2]:               60 C: devices=C389
> active[3]:               45 C: devices=C38A
> active[4]:               35 C: devices=C38B
> <setting not supported>
> <polling disabled>
> state:                   ok
> temperature:             94 C
> critical (S5):           105 C
> <setting not supported>
> <polling disabled>
> state:                   active[1]
> temperature:             76 C
> critical (S5):           105 C
> active[0]:               100 C: devices=C36F
> active[1]:               70 C: devices=C36A
> active[2]:               60 C: devices=C36B
> active[3]:               55 C: devices=C36C
> active[4]:               45 C: devices=C36D
> active[5]:               35 C: devices=C36E
> <setting not supported>
> <polling disabled>
> state:                   ok
> temperature:             61 C
> critical (S5):           105 C
> passive:                 95 C: tc1=1 tc2=2 tsp=300 devices=CPU0 CPU1
> <setting not supported>
> <polling disabled>
> state:                   ok
> temperature:             28 C
> critical (S5):           105 C
> passive:                 60 C: tc1=1 tc2=2 tsp=300 devices=CPU0 CPU1
> <setting not supported>
> <polling disabled>
> state:                   ok
> temperature:             100 C
> critical (S5):           110 C

Are the fan(s) running? What does /proc/acpi/fan/*/* show?

