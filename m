Return-Path: <linux-kernel-owner+w=401wt.eu-S1752224AbZL3MEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbZL3MEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZL3MEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:04:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:51001 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752109AbZL3MEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:04:30 -0500
Cc: linux-kernel@vger.kernel.org, trenn@suse.de, mmalygin@ked.de,
       hancockrwd@gmail.com, greg@kroah.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="iso-8859-1"
Date: Wed, 30 Dec 2009 13:04:28 +0100
From: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20091230120428.5780@gmx.net>
MIME-Version: 1.0
Subject: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix FailSafe
 issue?
To: Tejun Heo <tj@kernel.org>, js@sig21.net
X-Authenticated: #21834385
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/XWP9gG33XfEmYdsyRPRSqWUEomgOv0PKgFqphVA
 Ecjexio488KRcAOXWx1LAbxSYOuxdkVmhz0w== 
X-GMX-UID: gzRaLytja0A7XvBFODAzh7Q/Njh6dM6x
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Betreff: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix FailSafe issue?

> Hello,
> 
> On 11/30/2009 07:21 PM, Johannes Stezenbach wrote:
> > I've booted with rdinit=/bin/sh (busybox sh in initramfs), so
> > nothing accesses the disk.  After 5min the C state switch
> > happens, but no ATA exception. I waited a few more miniutes
> > and then used dd if=/dev/sda of=/dev/null  -> ATA exception.
> > There is no way to escape it.
> 
> Ah, okay, so whatever follows the switch times out.
> 
> I have no idea what to do about it at this point.  :-(
> 
> -- 
> tejun

Tejun,

testing in the Arch Linux Forums has shown that if one applies
a patch which you posted to the linux-ide ML on 2008-11-21
then the problem is no longer seen. Instead the kernel log shows
that a spurious IRQ was cleared.

[PATCH #upstraem-fixes] ata_piix: detect and clear spurious IRQs
http://marc.info/?l=linux-ide&m=122724081603679&w=2
http://bbs.archlinux.org/viewtopic.php?id=86454

What's the current status of this patch? Is it safe to use?
What does it tell us about the Samsung N130/140?

Regards,
Hans

-- 
Release early, release often.

GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
