Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbZDIDQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbZDIDQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZDIDQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:16:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638AbZDIDQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:16:14 -0400
Date: Wed, 8 Apr 2009 20:14:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Justin Madru <jdm64@gawab.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.30-rc1: intel 3945 no wireless
Message-Id: <20090408201414.9161568f.akpm@linux-foundation.org>
In-Reply-To: <49DC37F0.2040408@gawab.com>
References: <49DC37F0.2040408@gawab.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-wireless)

On Tue, 07 Apr 2009 22:36:48 -0700 Justin Madru <jdm64@gawab.com> wrote:

> Hi,
> 
> Decided to test out .30-rc1, but I've run into some bugs.
> My intel 3945 wireless card doesn't work. Bellow is the relevant 
> portions of dmesg
> The full dmesg and config can be found at: 
> http://jdserver.homelinux.org/bugreports/003/
> 
> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for 
> Linux, 1.2.26ks
> iwl3945: Copyright(c) 2003-2009 Intel Corporation
> iwl3945 0000:0b:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> iwl3945 0000:0b:00.0: setting latency timer to 64
> input: SynPS/2 Synaptics TouchPad as 
> /devices/platform/i8042/serio1/input/input6
> iwl3945 0000:0b:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
> iwl3945 0000:0b:00.0: Detected Intel Wireless WiFi Link 3945ABG
>   alloc irq_desc for 26 on cpu 0 node 0
>   alloc kstat_irqs on cpu 0 node 0
> iwl3945 0000:0b:00.0: irq 26 for MSI/MSI-X
> phy0: Selected rate control algorithm 'iwl-3945-rs'
> input: HDA Intel Mic at Ext Right Jack as 
> /devices/pci0000:00/0000:00:1b.0/input/input7
> input: HDA Intel HP Out at Ext Right Jack as 
> /devices/pci0000:00/0000:00:1b.0/input/input8
> phy0: Failed to initialize wep: -2
> iwl3945 0000:0b:00.0: Failed to register hw (error -2)
> iwl3945 0000:0b:00.0: PCI INT A disabled
> iwl3945: probe of 0000:0b:00.0 failed with error -2
> 

I assume this is a regression?  2.6.29 was OK?
