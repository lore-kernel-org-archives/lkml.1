Return-Path: <linux-kernel-owner+w=401wt.eu-S965436AbXBFBQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965436AbXBFBQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 20:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965435AbXBFBQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 20:16:23 -0500
Received: from homer.mvista.com ([63.81.120.158]:10049 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965430AbXBFBQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 20:16:22 -0500
Subject: Re: v2.6.20-rt1, yum/rpm
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070205065636.GA1652@elte.hu>
References: <20070205065636.GA1652@elte.hu>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 17:14:17 -0800
Message-Id: <1170724457.9781.327.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The /proc/interrupts timer entry is dangling a little. With PREEMPT_RT
the entry doesn't get updated ..

My system after two hours uptime,

           CPU0       CPU1       
  0:         56          0   IO-APIC-edge      timer
  1:          2          0   IO-APIC-edge      i8042
  4:       1450          0   IO-APIC-edge      serial
  6:          3          0   IO-APIC-edge      floppy
  8:          0          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          4          0   IO-APIC-edge      i8042
 14:     824890          0   IO-APIC-edge      ide0
 17:        182          0   IO-APIC-fasteoi   HDA Intel
 20:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 21:          0          0   IO-APIC-fasteoi   libata, ehci_hcd:usb1, uhci_hcd:usb4
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 23:       7515          0   IO-APIC-fasteoi   uhci_hcd:usb5, eth0
NMI:          0          0 
LOC:    1749635    1749614 
ERR:          0

Daniel

