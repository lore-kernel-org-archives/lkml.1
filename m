Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZGWTwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZGWTwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZGWTw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:52:29 -0400
Received: from indigo.cs.bgu.ac.il ([132.72.42.23]:58172 "EHLO
	indigo.cs.bgu.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbZGWTw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:52:29 -0400
Date: Thu, 23 Jul 2009 22:36:46 +0300 (IDT)
Message-Id: <200907231936.n6NJakbL003030@indigo.cs.bgu.ac.il>
From: "eial@cs.bgu.ac.il" <eial@cs.bgu.ac.il>
To: linux-kernel@vger.kernel.org
Subject: max freq is 2.1, but current freq is between min.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Organization: CS Department
X-Mailer: CS Webmail v3.10
X-Priority: 3 (Normal)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a t8100 cpu, running gentoo, I've tried both kernels 2.6.29 and 30, but for no avail.
I have 4 stepping: 2.10 GHz, 2.10 GHz, 1.60 GHz, 1.20 GHz but under all governors, the max freq is 1.2 it changes here and there: cpufreq-info shows this:

cpufrequtils 005: cpufreq-info (C) Dominik Brodowski 2004-2006                         
Report errors and bugs to cpufreq@vger.kernel.org, please.                             
analyzing CPU 0:                                                                       
  driver: acpi-cpufreq                                                                 
  CPUs which need to switch frequency at the same time: 0                               
  hardware limits: 1.20 GHz - 2.10 GHz                                                 
  available frequency steps: 2.10 GHz, 2.10 GHz, 1.60 GHz, 1.20 GHz                     
  available cpufreq governors: conservative, userspace, powersave, ondemand, performance
  current policy: frequency should be within 1.20 GHz and 1.20 GHz.                     <----- range is not ok
                  The governor "performance" may decide which speed to use             
                  within this range.                                                   
  current CPU frequency is 1.20 GHz.                                                   
  cpufreq stats: 2.10 GHz:27.11%, 2.10 GHz:1.19%, 1.60 GHz:1.25%, 1.20 GHz:70.45%  (218)
analyzing CPU 1:                                                                       
  driver: acpi-cpufreq                                                                 
  CPUs which need to switch frequency at the same time: 1                               
  hardware limits: 1.20 GHz - 2.10 GHz                                                 
  available frequency steps: 2.10 GHz, 2.10 GHz, 1.60 GHz, 1.20 GHz                     
  available cpufreq governors: conservative, userspace, powersave, ondemand, performance
  current policy: frequency should be within 1.20 GHz and 1.20 GHz.                     
                  The governor "performance" may decide which speed to use             
                  within this range.                                                   
  current CPU frequency is 1.20 GHz.                                                   
  cpufreq stats: 2.10 GHz:27.51%, 2.10 GHz:1.23%, 1.60 GHz:1.30%, 1.20 GHz:69.96%  (232)

and at other times, this:

cpufrequtils 005: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to cpufreq@vger.kernel.org, please.
analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which need to switch frequency at the same time: 0
  hardware limits: 1.20 GHz - 2.10 GHz
  available frequency steps: 2.10 GHz, 2.10 GHz, 1.60 GHz, 1.20 GHz
  available cpufreq governors: conservative, userspace, powersave, ondemand, performance
  current policy: frequency should be within 1.20 GHz and 2.10 GHz.
                  The governor "performance" may decide which speed to use
                  within this range.
  current CPU frequency is 2.10 GHz.
  cpufreq stats: 2.10 GHz:34.33%, 2.10 GHz:1.96%, 1.60 GHz:2.01%, 1.20 GHz:61.70%  (221)
analyzing CPU 1:
  driver: acpi-cpufreq
  CPUs which need to switch frequency at the same time: 1
  hardware limits: 1.20 GHz - 2.10 GHz
  available frequency steps: 2.10 GHz, 2.10 GHz, 1.60 GHz, 1.20 GHz
  available cpufreq governors: conservative, userspace, powersave, ondemand, performance
  current policy: frequency should be within 1.20 GHz and 2.10 GHz.  <----- range is ok
                  The governor "performance" may decide which speed to use
                  within this range.
  current CPU frequency is 2.10 GHz.
  cpufreq stats: 2.10 GHz:34.67%, 2.10 GHz:1.99%, 1.60 GHz:2.06%, 1.20 GHz:61.28%  (235)

the range keeps changing, due this thing, it took e 6 and a half hours to compile openoffice, almost twice than the average time that I have compiled it before.
most of the time, the computer is unusable.I have no idea what else can be done, I've checked the bios, all ok, that is the latest version of bios, running boinc, compile and checking for broken libs keeps the freq at min...
I have no idea what to do.
I would appreciate the help.


