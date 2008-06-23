Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbYFWIwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbYFWIwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYFWIwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:52:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42604 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbYFWIwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:52:44 -0400
Date: Mon, 23 Jun 2008 10:53:38 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andreas Schwab <schwab@suse.de>
Cc: Tejun Heo <tj@kernel.org>, kernel list <linux-kernel@vger.kernel.org>,
       benh@kernel.crashing.org, jgarzik@pobox.com,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: sata_svw data corruption, strange problems
Message-ID: <20080623085338.GE1850@elf.ucw.cz>
References: <20080617093602.GA28140@elf.ucw.cz> <485EF061.3010601@kernel.org> <20080623082055.GB1850@elf.ucw.cz> <je63s0sfxv.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <je63s0sfxv.fsf@sykes.suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-06-23 10:39:40, Andreas Schwab wrote:
> Pavel Machek <pavel@suse.cz> writes:
> 
> > +	   controller, the controller could hang. In other cases it
> > +	   could return partial data returning in data
> > +	   corruption. This problem has been seen in PPC systems and
> 
> s/returning/resulting/ ?

Fix thinko in sata_svw comment.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index fb13b82..d6313f1 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -269,7 +269,7 @@ static void k2_bmdma_start_mmio(struct a
 	   would become confused as to what to do with the data.  In
 	   the worst case when all the data is returned back to the
 	   controller, the controller could hang. In other cases it
-	   could return partial data returning in data
+	   could return partial data resulting in data
 	   corruption. This problem has been seen in PPC systems and
 	   can also appear on an system with very fast disks, where
 	   the SATA controller is sitting behind a number of bridges,


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
