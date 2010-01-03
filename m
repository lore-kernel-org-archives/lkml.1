Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121Ab0ACWLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab0ACWLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 17:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058Ab0ACWLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 17:11:50 -0500
Received: from bar.sig21.net ([80.81.252.164]:39853 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab0ACWLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 17:11:50 -0500
Date: Sun, 3 Jan 2010 23:11:42 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Hans Werner <HWerner4@gmx.de>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, trenn@suse.de,
       mmalygin@ked.de, hancockrwd@gmail.com, greg@kroah.com
Subject: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix
 FailSafe issue?
Message-ID: <20100103221142.GA16783@sig21.net>
References: <20091230120428.5780@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230120428.5780@gmx.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.777,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 01:04:28PM +0100, Hans Werner wrote:
> 
> testing in the Arch Linux Forums has shown that if one applies
> a patch which you posted to the linux-ide ML on 2008-11-21
> then the problem is no longer seen. Instead the kernel log shows
> that a spurious IRQ was cleared.
> 
> [PATCH #upstraem-fixes] ata_piix: detect and clear spurious IRQs
> http://marc.info/?l=linux-ide&m=122724081603679&w=2
> http://bbs.archlinux.org/viewtopic.php?id=86454
> 
> What's the current status of this patch? Is it safe to use?
> What does it tell us about the Samsung N130/140?

FWIW, I just tested a current git kernel (v2.6.33-rc2-268-g45d28b0)
with Tejun's patch applied on my N130.  The ATA exception and hang is
indeed gone, just "ata1: clearing spurious IRQ" is logged.

I've see Tejun's comment in
http://bugzilla.kernel.org/show_bug.cgi?id=14314
and I would like to add that the ATA irq is not shared.

 14:      43885          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix


Thanks,
Johannes
