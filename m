Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbXA2Wav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbXA2Wav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXA2Wav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:30:51 -0500
Received: from www.osadl.org ([213.239.205.134]:54666 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752620AbXA2Wau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:30:50 -0500
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <20070129142359.517b1980@freekitty>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <1169931333.17469.125.camel@localhost.localdomain>
	 <20070129113159.7ad22e4c@freekitty>
	 <1170101430.29240.34.camel@localhost.localdomain>
	 <20070129133849.1b523226@freekitty>
	 <1170109401.29240.49.camel@localhost.localdomain>
	 <20070129142359.517b1980@freekitty>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 23:31:31 +0100
Message-Id: <1170109892.29240.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 14:23 -0800, Stephen Hemminger wrote:
> > Still the same problem. The only difference of this patch to the
> > previous version is, that the unhandled interrupt message is gone.
> > 
> > As I said before:
> > 
> > Reverting commit 44ade178249fe53d055fd92113eaa271e06acddd, which added
> > this hackery in the first place, makes the device survive
> > suspend/resume.

> But the fix is necessary on laptops where ACPI messes with MSI/INTx
> on resume.

And the fix is unnecessary and counter productive on laptops, where ACPI
does the right thing.

	tglx


