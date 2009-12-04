Return-Path: <linux-kernel-owner+w=401wt.eu-S932258AbZLDQ7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbZLDQ7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbZLDQ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:59:10 -0500
Received: from mailout02.t-online.de ([194.25.134.17]:51383 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbZLDQ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:59:09 -0500
Message-ID: <4B193FDF.3060404@t-online.de>
Date: Fri, 04 Dec 2009 17:59:11 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091202 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.32, hda_codec: kernel gets stuck for 3 minutes at boot time
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: EYWo26ZDQh-s8MISjC1gTp2DqUyldELbeDVbjAGJI5lD2daBfefp6p3KxtIPgjrwXc
X-TOI-MSGID: d9173385-094a-4054-a8fa-8d77eedbf043
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

2.6.32(amd64) gets stuck for about 3 minutes at boot time. dmesg says:

:
[   15.026892] HDA Intel 0000:00:08.0: power state changed by ACPI to D0
[   15.041001] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 20
[   15.054443] HDA Intel 0000:00:08.0: PCI INT A -> Link[LAZA] -> GSI 20 (level, low) -> IRQ 20
[   15.067718] HDA Intel 0000:00:08.0: setting latency timer to 64
[   15.424080] hda_codec: ALC662 rev1: BIOS auto-probing.
[  190.728138] Adding 1959920k swap on /dev/sda2.  Priority:-1 extents:1 across:1959920k
[  191.268572] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
:


I get the same for 2.6.31.6. I cannot remember having seen this for
kernel 2.6.29.x.

Hardware is an Acer Aspire Revo R3600. A bios update to the most recent
version did not help.


Any helpful comment or hint would be highly appreciated.


Regards

Harri
