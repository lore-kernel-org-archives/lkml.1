Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYH1A7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYH1A7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYH1A7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:59:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44948 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbYH1A7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:59:39 -0400
Message-ID: <48B5F877.8030506@garzik.org>
Date: Wed, 27 Aug 2008 20:59:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Robert M. Stockmann" <stock@stokkie.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: libata, Sound on same IRQ : flaky sound
References: <Pine.LNX.4.44.0808280147230.1242-100000@hubble.stokkie.net>
In-Reply-To: <Pine.LNX.4.44.0808280147230.1242-100000@hubble.stokkie.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert M. Stockmann wrote:
> Hi,
> 
> I have a couple of AMD64 machines with onboard sound devices running 
> and they all have one thing in common : flaky sound when one is 
> doing some heavy disk I/O on the SATA disks. Interesting enough 
> /proc/interrupts shows that libata is using the same IRQ as the sound 
> devices :
> 
> model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
> stepping        : 3
> cpu MHz         : 3014.679
> cache size      : 1024 KB
> 
> # cat /proc/interrupts 
>            CPU0       CPU1       
>   0:      55869  154467838    IO-APIC-edge  timer
>   8:          0          0    IO-APIC-edge  rtc
>   9:          0          0   IO-APIC-level  acpi
>  16:       1453     499686   IO-APIC-level  libata, NVidia CK8S
>  17:          0          0   IO-APIC-level  ehci_hcd:usb1
>  18:      27633   69978987   IO-APIC-level  eth0
> NMI:      10718      12112 
> LOC:  154533874  154533852 
> ERR:          0
> MIS:          0

What is the behavior of a recent kernel?

Is your SATA interface set to legacy mode in BIOS?

	Jeff


