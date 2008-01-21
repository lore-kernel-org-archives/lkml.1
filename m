Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbYAUIP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbYAUIP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 03:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbYAUIPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 03:15:51 -0500
Received: from aun.it.uu.se ([130.238.12.36]:46384 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757945AbYAUIPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 03:15:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18324.21679.979192.4576@harpo.it.uu.se>
Date: Mon, 21 Jan 2008 09:15:43 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: "william cheng" <opensourcewill@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: modprobing ipmi_si on Dell Power Edge 2600 make the terminal hang kernel ver. >= 2.6.20
In-Reply-To: <7d34f9680801201740u4eb912eel921e7890b4ac023a@mail.gmail.com>
References: <7d34f9680801201740u4eb912eel921e7890b4ac023a@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

william cheng writes:
 > Dear all,
 > 
 >         We got some problem on modprobing the ipmi_si module on Dell
 > Power Edge 2600.
 >         On modprobing the ipmi_si the terminal hang and the process
 > cannot be terminated by control-C.
 >         We got these messages in dmesg
 > 
 >         ipmi message handler version 39.1
 >         IPMI System Interface driver.
 >         ipmi_si: Trying SMBIOS-specified bt state machine at i/o
 > address 0xe4, slave address 0x20, irq 10
 >           Using irq 10
 >         IPMI BT: req2rsp=10 secs retries=3
 >         ipmi_si: Error clearing flags: c6
 > 
 > 
 >         We have tested a few other dell machine (Power Edge 2500,
 > 2900, ....), and this problem only occurs in Power Edge 2600.
 > 
 > 
 >         The problem occurs in the following testes
 >         Debian testing lenny
 >         Ubuntu 7.10
 >         Ubuntu 7.04
 >         Fedore 8
 >         Kernel 2.6.20
 >         Kernel 2.6.21
 >         Kernel 2.6.22
 >         Kernel 2.6.22.5
 >         Kernel 2.6.22.14
 >         Kernel 2.6.22.15
 >         Kernel 2.6.23.12
 > 
 >         While in the following testes we can successfully modprobe the ipmi_si
 >         Ubuntu 6.10
 >         Debian 4.0r2
 >         Kernel 2.6.18.3
 >         Kernel 2.6.18.5
 >         Kernel 2.6.18.8
 >         Kernel 2.6.19
 >         Kernel 2.6.19.7
 > 
 >         It looks like the problem only occurs when using kernel after
 > 2.6.20 with Power Edge 2600.

I saw the same loop when upgrading a PE2600 from an RHEL4 2.6.9
kernel to an RHEL5 2.6.18 kernel. Since I had no interest in ipmi_si
I just de-configured it and wrote it off as yet another RHEL bug.
Seems now that RedHat backported an upstream bug :-(
