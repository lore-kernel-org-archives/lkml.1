Return-Path: <linux-kernel-owner+w=401wt.eu-S936405AbXG0G0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936405AbXG0G0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 02:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760503AbXG0G0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 02:26:12 -0400
Received: from rzcomm12.rz.tu-bs.de ([134.169.9.59]:56758 "EHLO
	rzcomm12.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670AbXG0G0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 02:26:12 -0400
Message-ID: <46A98FF9.8060801@l4x.org>
Date: Fri, 27 Jul 2007 08:26:01 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Thunderbird 2.0.0.5pre (Windows/20070723)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
References: <200707251238.50218.lenb@kernel.org>
In-Reply-To: <200707251238.50218.lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> Hi Linus,
> 
> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This seems to break ia64 defconfig:

   Building modules, stage 2.
   MODPOST 157 modules
FATAL: drivers/acpi/button: sizeof(struct acpi_device_id)=20 is not a modulo of the size of section __mod_acpi_device_table=144.
Fix definition of struct acpi_device_id in mod_devicetable.h
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make: *** [_all] Error 2

gcc 3.3.6, binutils 2.15.94

http://l4x.org/k/?d=32569

Jan
