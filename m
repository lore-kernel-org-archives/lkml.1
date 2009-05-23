Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbZEWAgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbZEWAgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 20:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZEWAf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 20:35:57 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:47885 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZEWAf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 20:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <tkrat.acafb37c21e20784@s5r6.in-berlin.de>
References: <tkrat.d86e749d664670a9@s5r6.in-berlin.de> <ac3eb2510905211001m77eda9e4gb73001d504fd5376@mail.gmail.com> 
	<4A159899.20506@s5r6.in-berlin.de> <4A165CED.8030601@s5r6.in-berlin.de> 
	<ac3eb2510905220423h23e7aca1u3bc7c204db551eb0@mail.gmail.com> 
	<tkrat.7b837daea0cfa5b2@s5r6.in-berlin.de> <tkrat.acafb37c21e20784@s5r6.in-berlin.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 23 May 2009 02:35:36 +0200
Message-ID: <ac3eb2510905221735lc5de01j334618ddeb72a813@mail.gmail.com>
Subject: Re: [PATCH 2/2] firewire: core: add sysfs attribute for easier udev 
	rules
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-hotplug@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 23:17, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> This adds the attribute /sys/bus/firewire/devices/fw[0-9]+/units.  It
> can be used in udev rules like the following ones:
>
> # IIDC devices: industrial cameras and some webcams
> SUBSYSTEM=="firewire", ATTR{units}=="*0x00a02d:0x00010?*", GROUP="video"
>
> # AV/C devices: camcorders, set-top boxes, TV sets, audio devices, ...
> SUBSYSTEM=="firewire", ATTR{units}=="*0x00a02d:0x010001*", GROUP="video"

> Here is an example of a node which implements an IPv4 unit and an IPv6
> unit:  $ cat /sys/bus/firewire/devices/fw2/units
> 0x00005e:0x000001 0x00005e:0x000002

Looks great. Let me know when you are merging this, so we can put the
rules in the udev tree.

Thanks,
Kay
