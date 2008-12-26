Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbYLZTad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbYLZTad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 14:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYLZTaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 14:30:25 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58303 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYLZTaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 14:30:24 -0500
Date: Fri, 26 Dec 2008 20:30:19 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
In-Reply-To: <20080226112840.GA29465@uranus.ravnborg.org>
Message-ID: <alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <20080226112840.GA29465@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-02-26 12:28, Sam Ravnborg wrote:
>> 
>> (I've sent this to the linux-kbuild and linux-kernel lists as this
>> patch modifies the Makefile.modinst file. I also don't subscribe to the 
>> linux-kbuild and linux-kernel mailing lists so can I have any replies
>> CC'ed to me please)
>> 
>> This patch allows kernel modules to be compressed when 'make
>> modules_install' is run after being copied to
>> the /lib/module/<version>/<...> directory which is useful if you have
>> module-init-tools installed with --enable-zlib. This patch adds an
>> option (MODULE_COMPRESS) to the kernel configuration file (specifically
>> init/Kconfig) so that the kernel modules will compressed if
>> MODULE_COMPRESS is set.

I recently started compressing my kernel modules and that saved me
at least 70 MB of disk space on mostlyallmodconfig.
(And no, the argument of disks being cheap is not so true with
CF or SSD.)
Distro is lazy and wants to wait for upstream to have it,
so is there any chance of getting this proposal in?


Jan
