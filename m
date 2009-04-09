Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbZDIDbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbZDIDbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbZDIDbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:31:20 -0400
Received: from fmailhost02.isp.att.net ([204.127.217.102]:58198 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702AbZDIDbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:31:19 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49DD6BF7.3040400@lwfinger.net>
Date: Wed, 08 Apr 2009 22:31:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: 2.6.30-rc1: intel 3945 no wireless
References: <49DC37F0.2040408@gawab.com> <20090408201414.9161568f.akpm@linux-foundation.org>
In-Reply-To: <20090408201414.9161568f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc linux-wireless)
> 
> On Tue, 07 Apr 2009 22:36:48 -0700 Justin Madru <jdm64@gawab.com> wrote:
> 
>> Hi,
>>
>> Decided to test out .30-rc1, but I've run into some bugs.
>> My intel 3945 wireless card doesn't work. Bellow is the relevant 
>> portions of dmesg
>> The full dmesg and config can be found at: 
>> http://jdserver.homelinux.org/bugreports/003/
>>
>> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for 
>> Linux, 1.2.26ks
>> iwl3945: Copyright(c) 2003-2009 Intel Corporation
>> iwl3945 0000:0b:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> iwl3945 0000:0b:00.0: setting latency timer to 64
>> input: SynPS/2 Synaptics TouchPad as 
>> /devices/platform/i8042/serio1/input/input6
>> iwl3945 0000:0b:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
>> iwl3945 0000:0b:00.0: Detected Intel Wireless WiFi Link 3945ABG
>>   alloc irq_desc for 26 on cpu 0 node 0
>>   alloc kstat_irqs on cpu 0 node 0
>> iwl3945 0000:0b:00.0: irq 26 for MSI/MSI-X
>> phy0: Selected rate control algorithm 'iwl-3945-rs'
>> input: HDA Intel Mic at Ext Right Jack as 
>> /devices/pci0000:00/0000:00:1b.0/input/input7
>> input: HDA Intel HP Out at Ext Right Jack as 
>> /devices/pci0000:00/0000:00:1b.0/input/input8
>> phy0: Failed to initialize wep: -2
>> iwl3945 0000:0b:00.0: Failed to register hw (error -2)
>> iwl3945 0000:0b:00.0: PCI INT A disabled
>> iwl3945: probe of 0000:0b:00.0 failed with error -2
>>
> 
> I assume this is a regression?  2.6.29 was OK?

See the discussion in the thread containing
http://marc.info/?l=linux-kernel&m=123922531327539&w=2. This one also contains
the fix that was accepted by Rusty Russell.

Larry
