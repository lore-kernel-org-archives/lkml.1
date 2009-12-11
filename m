Return-Path: <linux-kernel-owner+w=401wt.eu-S1762362AbZLKTzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762362AbZLKTzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 14:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761823AbZLKTzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 14:55:50 -0500
Received: from borg.medozas.de ([188.40.89.202]:60450 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761752AbZLKTzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 14:55:49 -0500
Date: Fri, 11 Dec 2009 20:55:53 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: nir.tzachar@gmail.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: nconfig v7
Message-ID: <alpine.LSU.2.01.0912112023170.32039@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I gave nconfig a try, and here are a few suggestive points:

- provide the same color scheme as menuconfig

- I get a visual glitch (see Exhibit A below) in General setup (patch
  slapped onto 2.6.32); the left frame part is missing.

- For symbol info, it would be cool if it wrapped the "Selected by"
  line (menuconfig also "suffers" from this), because that one can
  get exceptionally long and awkward to scroll.

- I certainly like F4-Config-ShowAll :)  but it has some glitches
  interfering near ARCH_DEFCONFIG (see Exhibit B).



----(Exhibit A)
                  .config - Linux Kernel v2.6.32 Configuration
 ┌── General setup ───────────────────────────────────────────────────────────┐
 │                                                                            │
  [*] Prompt for development and/or incomplete code/drivers                   │
  ()  Local version - append to kernel release                                │
  [ ] Automatically append version information to the version string          │
  [*] Support for paging of anonymous memory (swap)                           │
  [*] System V IPC                                                            │
  [*] POSIX Message Queues                                                    │
  [*] BSD Process Accounting                                                  │
  [ ]   BSD Process Accounting version 3 file format                          │
  [*] Export task/process statistics through netlink (EXPERIMENTAL)           │
  [*]   Enable per-task delay accounting (EXPERIMENTAL)                       │
  [*]   Enable extended accounting over taskstats (EXPERIMENTAL)              │
  [*]     Enable per-task storage I/O accounting (EXPERIMENTAL)               │
  [*] Auditing support                                                        │
  [*]   Enable system-call auditing support                                   │
      RCU Subsystem  --->                                                     │
  < > Kernel .config support                                                  │
  (17) Kernel log buffer size (16 => 64KB, 17 => 128KB)                       │
  [*] Group CPU scheduler                                                     │
 │                                                                            │
 │                                                                            │
 └F1Help─F2Symbol Info─F3Instructions─F4Config─F5Back─F6Save─F7Load─F8Exit────┘
----

----(Exhibit B)
 ┌── Linux Kernel Configuration ──────────────────────────────────────────────┐
 │                                                                            │
 │          XXX 64-bit kernel                                                 │
 │          XXX SPARC                                                         │
 │          XXX SPARC32                                                       │
 │          XXX SPARC64                                                       │
 │          XXXch/sparc/configs/sparc64_defconfig) ARCH_DEFCONFIG             │
 │          XXX) BITS                                                         │
 │          XXX GENERIC_TIME                                                  │
...
----
