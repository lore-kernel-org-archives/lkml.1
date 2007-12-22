Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbXLVSHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbXLVSHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 13:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXLVSHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 13:07:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416AbXLVSHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 13:07:06 -0500
Date: Sat, 22 Dec 2007 10:06:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
In-Reply-To: <20071222064719.73fdd9a4@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Dec 2007, Arjan van de Ven wrote:

> On Sat, 22 Dec 2007 09:20:06 -0500
> Jeff Garzik <jeff@garzik.org> wrote:
> > 
> > Yuck.  And, Linus is just being silly.  Wait a year then turn on 
> > MMCONFIG :)  It took PCI MSI a while to mature, but is finally
> > getting there.

That _really_ doesn't work.

Old machines don't go away. We can't just say "wait a year and turn on 
MMCONFIG", because all the broken machines WILL STILL EXIST.

> Do you hate the name or the concept? I'm certainly open for a better name.... 

Just make it so. The name is fine, the concept is unavoidable. The people 
who complain are whiners that haven't ever had to deal with the fact that 
there are broken machines around. 

For example, right now Jeff never sees the problem, because when MMCONFIG 
doesn't work, it's never his problem - nothing in the machine works. But 
if he has to add a "pci_enable_mmconfig()" to the drivers he maintains, he 
sees it as a _new_ problem, so he obviously thinks it's stupid: he was 
never impacted by the issues it fixed!

So it's natural for Jeff to not like it, but that doesn't make Jeff right 
in this case. It just means that Jeff never had to worry about it before, 
because as long as MMCONFIG wasn't per-driver, the problems it caused were 
never *his* problems. But that doesn't make them less of a problem.

			Linus
