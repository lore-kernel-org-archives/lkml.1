Return-Path: <linux-kernel-owner+w=401wt.eu-S1761773AbXFIVFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761773AbXFIVFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 17:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760190AbXFIVFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 17:05:24 -0400
Received: from www.osadl.org ([213.239.205.134]:47446 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760151AbXFIVFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 17:05:23 -0400
Subject: Re: Jinxed VAIO wreckage - current state of affairs
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>
In-Reply-To: <200706092259.50694.rjw@sisk.pl>
References: <1181418873.4404.402.camel@chaos>
	 <200706092259.50694.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 09 Jun 2007 23:05:21 +0200
Message-Id: <1181423121.4404.430.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-09 at 22:59 +0200, Rafael J. Wysocki wrote:
> > Can the suspend/resume and ACPI wizards please give some hint how to
> > track this 100% reproducible wreckage down.
> 
> Hmm, how's 2.6.22-rc4-mm2 doing on the Vaio?
> 
> There are a couple of patches in there that might help in theory, this series
> in particular:
> 
> swsusp-remove-incorrect-code-from-userc.patch
> swsusp-remove-code-duplication-between-diskc-and-userc.patch
> swsusp-introduce-restore-platform-operations.patch
> swsusp-fix-hibernation-code-ordering.patch
> swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch

I'm working on a hrt version against -mm, so we can figure this out.

	tglx


