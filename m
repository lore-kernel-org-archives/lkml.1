Return-Path: <linux-kernel-owner+w=401wt.eu-S1763466AbYBPBJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763466AbYBPBJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 20:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbYBPBJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 20:09:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46995 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757182AbYBPBJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 20:09:15 -0500
Date: Fri, 15 Feb 2008 17:09:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, greg@kroah.com
Subject: Re: [PATCH 00/14] [ISDN] HiSax hotplug conversion
Message-Id: <20080215170902.09f0f798.akpm@linux-foundation.org>
In-Reply-To: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 23:04:04 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> This is a refresh of an on-going work-in-progress:  convert the last
> remaining users of pci_find_device() to the ISA/PCI/etc.  hotplug APIs
> now in standard use.  After SCSI's gdth, ISDN's HiSax suite of drivers
> are just about the last place using the older API.
> 
> A few rough edges remain, and I'm not sure how much of ISDN userland
> will explode (I have no ISDN hardware, nor much want any:)), but this
> should get us almost all the way there.
> 
> The patches are diff'd against 2.6.25-rc1.
> 
> Comments/review/testing welcome.  Especially "it works" or "its dead"
> testing.

When `make modules_install' runs depmod using
http://userweb.kernel.org/~akpm/config-akpm2.txt these patches cause this:


WARNING: Module /lib/modules/2.6.25-rc2-mm1/kernel/drivers/isdn/hisax/teles_cs.ko ignored, due to loop
WARNING: Module /lib/modules/2.6.25-rc2-mm1/kernel/drivers/isdn/hisax/hisax_st5481.ko ignored, due to loop
WARNING: Module /lib/modules/2.6.25-rc2-mm1/kernel/drivers/isdn/hisax/elsa_cs.ko ignored, due to loop
WARNING: Module /lib/modules/2.6.25-rc2-mm1/kernel/drivers/isdn/hisax/hfc4s8s_l1.ko ignored, due to loop
WARNING: Module /lib/modules/2.6.25-rc2-mm1/kernel/drivers/isdn/hisax/hisax_isac.ko ignored, due to loop
WARNING: Module /lib/modules/2.6.25-rc2-mm1/kernel/drivers/isdn/hisax/avma1_cs.ko ignored, due to loop
WARNING: Module /lib/modules/2.6.25-rc2-mm1/kernel/drivers/isdn/hisax/libhisax.ko ignored, due to loop
WARNING: Loop detected: /lib/modules/2.6.25-rc2-mm1/kernel/drivers/isdn/hisax/hisax.ko needs libhisax.ko which needs hisax.ko again!
WARNING: Module /lib/modules/2.6.25-rc2-mm1/kernel/drivers/isdn/hisax/hisax.ko ignored, due to loop
WARNING: Module /lib/modules/2.6.25-rc2-mm1/kernel/drivers/isdn/hisax/sedlbauer_cs.ko ignored, due to loop
WARNING: Module /lib/modules/2.6.25-rc2-mm1/kernel/drivers/isdn/hisax/hisax_fcpcipnp.ko ignored, due to loop
