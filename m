Return-Path: <linux-kernel-owner+w=401wt.eu-S1030607AbXBFXte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030607AbXBFXte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030610AbXBFXte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:49:34 -0500
Received: from mail.dbd-breitband.de ([217.188.211.21]:31674 "EHLO
	dbd-mpx01.dbd-breitband.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030607AbXBFXtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:49:32 -0500
From: Marc Donner <donner@dbd-breitband.de>
Organization: DBD DeutscheBreitbandDienste
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: cpu load balancing problem on smp
Date: Wed, 7 Feb 2007 00:49:51 +0100
User-Agent: KMail/1.9.5
References: <200702061832.17771.donner@dbd-breitband.de> <200702061941.32907.donner@dbd-breitband.de> <45C8CC2A.90403@linux.intel.com>
In-Reply-To: <45C8CC2A.90403@linux.intel.com>
X-Face: 8wX"obNKFY5e`AQ_k`>jn=23vm("ew,/l"P1@qcYiQ[nNGR08P\M^7k(=?utf-8?q?tG=26bz=5CH=3BP=7E1w0O=0A=09+wJq=5C=5Dfy=3DyWGLWBIsnq-L7?=<(<bD6#1Wwuz(fd2tH)r8l'q|U
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702070049.51536.donner@dbd-breitband.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> can you send me the output of
>
> cat /proc/interrupts
 
here it is:
irqblance is running.
network loaded with 600Mbit/s for about 5minutes. 

          CPU0       CPU1       CPU2       CPU3
  0:      37713      41667      41673      49914   IO-APIC-edge      timer
  1:          0          0          2          0   IO-APIC-edge      i8042
  8:          0          0          1          0   IO-APIC-edge      rtc
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          2          0          2          0   IO-APIC-edge      i8042
 14:         11          9          9          8   IO-APIC-edge      ide0
 20:          0          0          0          0   IO-APIC-fasteoi   
uhci_hcd:usb3
 21:         62         52         37         46   IO-APIC-fasteoi   
ehci_hcd:usb1, uhci_hcd:usb2, uhci_hcd:usb4
 78:        665        581        344        351   IO-APIC-fasteoi   megasas
501:     215717     209388     209430     202514   PCI-MSI-edge      eth10
502:        927       1019       1053        888   PCI-MSI-edge      eth11
NMI:        451         39         42         46
LOC:     170899     170864     170846     170788
ERR:          0

top output:

top - 01:45:32 up 16 min,  2 users,  load average: 1.04, 0.92, 0.50
Tasks:  81 total,   3 running,  78 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi, 100.0% si
Cpu1  :  0.0% us,  0.0% sy,  0.0% ni, 99.0% id,  1.0% wa,  0.0% hi,  0.0% si
Cpu2  :  0.0% us,  0.0% sy,  0.0% ni, 99.7% id,  0.0% wa,  0.0% hi,  0.3% si
Cpu3  :  0.0% us,  0.0% sy,  0.0% ni, 99.7% id,  0.0% wa,  0.3% hi,  0.0% si


regards
Marc
