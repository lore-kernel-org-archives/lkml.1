Return-Path: <linux-kernel-owner+w=401wt.eu-S934357AbZGQKBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357AbZGQKBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 06:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934349AbZGQKBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 06:01:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934345AbZGQKBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 06:01:35 -0400
Date: Fri, 17 Jul 2009 12:01:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: Input : regression - touchpad not detected
In-Reply-To: <a8e1da0907162213w13a5113dj556bb314e73fb19b@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0907171200350.27150@twin.jikos.cz>
References: <a8e1da0907162213w13a5113dj556bb314e73fb19b@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, Dave Young wrote:

> Hi,
> 
> since 2.6.31-rc3, sometimes the touchpad of my laptop will not be
> detected, usually after reboot it will be there.
> 
> I have no such problem with 2.6.31-rc2
> 
> `dmesg|grep input` with touchpad detected:
> 
> [    2.447119] input: Lid Switch as
> /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
> [    2.458089] input: Power Button as
> /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    2.459155] input: Sleep Button as
> /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
> [    3.093556] input: Video Bus as
> /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:33/input/input3
> [    3.120647] input: Video Bus as
> /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:3b/input/input4
> [    5.300364] input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input5
> [    5.669278] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input6
> [    5.698278] input: AlpsPS/2 ALPS GlidePoint as
> /devices/platform/i8042/serio1/input/input7
> 
> `dmesg|grep input` without touchpad detected:
> 
> [    2.454246] input: Lid Switch as
> /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
> [    2.478038] input: Power Button as
> /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    2.487538] input: Sleep Button as
> /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
> [    3.118063] input: Video Bus as
> /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:33/input/input3
> [    3.164064] input: Video Bus as
> /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:3b/input/input4
> [    5.353006] input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input5

Providing the dmesg output with 'i8042.debug' kernel parameter in place 
from the situation the TouchPad doesn't get detected might be helpful.

-- 
Jiri Kosina
SUSE Labs

