Return-Path: <linux-kernel-owner+w=401wt.eu-S1946497AbXBIPDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946497AbXBIPDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946503AbXBIPDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:03:00 -0500
Received: from www.osadl.org ([213.239.205.134]:47404 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946497AbXBIPC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:02:57 -0500
Subject: Re: -mm merge plans for 2.6.21
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070208154442.678a214b.akpm@linux-foundation.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	 <Pine.LNX.4.61.0702090023270.24888@yvahk01.tjqt.qr>
	 <20070208154442.678a214b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 16:02:52 +0100
Message-Id: <1171033372.3697.10.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-08 at 15:44 -0800, Andrew Morton wrote:
> Yeah, this seems to work.
> 
> +#define emit_old_interrupt_name(old, new)				\
> +static inline unsigned __deprecated emit_old_interrupt_name##old(void)	\
> +{									\
> +	return (new);							\
> +}
> +
> +emit_old_interrupt_name(SA_INTERRUPT, IRQF_DISABLED)
> +#define SA_INTERRUPT emit_old_interrupt_nameSA_INTERRUPT()

/me cringes, but if it makes people happy, so be it. Please update the
expiry date of this evil source of eye cancer.

	tglx

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 2dc5e5d..125a1c6 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -199,7 +199,7 @@ Who:	Nick Piggin <npiggin@suse.de>
 ---------------------------
 
 What:	Interrupt only SA_* flags
-When:	Januar 2007
+When:	August 2007
 Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
 	out of the signal namespace.
 


