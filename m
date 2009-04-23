Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbZDWTtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbZDWTtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZDWTtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:49:00 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:46153 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZDWTs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:48:59 -0400
Date: Thu, 23 Apr 2009 15:48:46 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: We La <w.landgraf@yahoo.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.30-rc3 : Regression: i915 , video
In-reply-to: <72010.86725.qm@web112215.mail.gq1.yahoo.com>
Message-id: <alpine.LFD.2.00.0904231537590.15830@localhost.localdomain>
References: <72010.86725.qm@web112215.mail.gq1.yahoo.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Problems on MSI U100 laptop:
> 
> root@werner:~# modprobe i915
> WARNING: Error inserting video (/lib/modules/2.6.30-rc3/kernel/drivers/acpi/video.ko): No such device
> FATAL: Error inserting i915 (/lib/modules/2.6.30-rc3/kernel/drivers/gpu/drm/i915/i915.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> root@werner:~#
> 
> Apr 23 16:16:57 localhost kernel: i915: Unknown symbol acpi_video_register
> 
> 
> On older kernels this drivers worked
> 
> Werner Landgraf
> Linux  SYS

you've got modular i915 and no acpi video driver?
Does this patch help?

http://patchwork.kernel.org/patch/18420/

thanks,
-Len Brown, Intel Open Source Technology Center

