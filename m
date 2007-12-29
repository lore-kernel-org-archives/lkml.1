Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbXL2OHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbXL2OHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 09:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbXL2OHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 09:07:21 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:42212 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbXL2OHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 09:07:20 -0500
Date: Sat, 29 Dec 2007 15:07:18 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: devzero@web.de
cc: jcm@jonmasters.org, dl9pf@gmx.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: modules_install regression ? - depmod
In-Reply-To: <75140323@web.de>
Message-ID: <Pine.LNX.4.64.0712291504540.23321@fbirervta.pbzchgretzou.qr>
References: <75140323@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 29 2007 14:30, devzero@web.de wrote:
>> On Dec 28 2007 16:08, devzero@web.de wrote:
>> >
>> >i have the same issue, but with 2.6.24-rc6 on a box with 512MB RAM
>> >
>> >System is openSUSE 10.3
>>
>> If you enable CONFIG_DEBUG_INFO, don't be surprised.
>
>oh yes, that`s it!
>
>apparently CONFIG_DEBUG_KERNEL, CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_INFO
>defaults to "y" on my distro`s kernel, and i just copied config from
>/proc/config.gz and did a "make oldconfig".

Erm... same system here -

$ gzip -cd /proc/config.gz | grep DEBUG_INFO
# CONFIG_DEBUG_INFO is not set

I think you managed to snafu something during building.
