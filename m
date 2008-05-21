Return-Path: <linux-kernel-owner+w=401wt.eu-S933496AbYEUJ5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbYEUJ5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760314AbYEUJ5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:57:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41396 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759761AbYEUJ5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:57:00 -0400
Date: Wed, 21 May 2008 11:57:52 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       macro@ds2.pg.gda.pl
Subject: i8259: cleanup codingstyle
Message-ID: <20080521095752.GE12763@elf.ucw.cz>
References: <20080520151528.GA1596@elf.ucw.cz> <20080520204750.GA31409@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520204750.GA31409@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i8259: trivial codingstyle cleanup.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 3333c67ab415a0debec8e178c563e81b49f73bf9
tree 9f868e4422e7d58bfe398541335b8574ea4c11ee
parent 800e1add46a2686995af98432a7971150318676d
author Pavel <pavel@amd.ucw.cz> Wed, 21 May 2008 11:57:12 +0200
committer Pavel <pavel@amd.ucw.cz> Wed, 21 May 2008 11:57:12 +0200

 arch/x86/kernel/i8259.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 433e49e..7a0fda8 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -129,14 +129,14 @@ static inline int i8259A_irq_real(unsign
 	int irqmask = 1<<irq;
 
 	if (irq < 8) {
-		outb(0x0B,PIC_MASTER_CMD);	/* ISR register */
+		outb(0x0B, PIC_MASTER_CMD);	/* ISR register */
 		value = inb(PIC_MASTER_CMD) & irqmask;
-		outb(0x0A,PIC_MASTER_CMD);	/* back to the IRR register */
+		outb(0x0A, PIC_MASTER_CMD);	/* back to the IRR register */
 		return value;
 	}
-	outb(0x0B,PIC_SLAVE_CMD);	/* ISR register */
+	outb(0x0B, PIC_SLAVE_CMD);	/* ISR register */
 	value = inb(PIC_SLAVE_CMD) & (irqmask >> 8);
-	outb(0x0A,PIC_SLAVE_CMD);	/* back to the IRR register */
+	outb(0x0A, PIC_SLAVE_CMD);	/* back to the IRR register */
 	return value;
 }
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
