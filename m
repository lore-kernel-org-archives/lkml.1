Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbZLFUPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbZLFUPx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757466AbZLFUPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:15:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:54475 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437AbZLFUPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:15:50 -0500
Date: Sun, 6 Dec 2009 12:18:03 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Message-ID: <20091206121803.70385c33@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0912061144100.3560@localhost.localdomain>
References: <200912052216.19540.rjw@sisk.pl>
	<200912060055.36130.rjw@sisk.pl>
	<alpine.LFD.2.00.0912051635330.3560@localhost.localdomain>
	<200912060254.10081.rjw@sisk.pl>
	<alpine.LFD.2.00.0912051758190.3560@localhost.localdomain>
	<20091206113555.5a646713@infradead.org>
	<alpine.LFD.2.00.0912061144100.3560@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009 11:58:44 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 6 Dec 2009, Arjan van de Ven wrote:
> > 
> > in suspend, there's a PCI device (:1b) that does take some time,
> > which is the audio controller. The bulk of the time is in the serio
> > driver though..
> 
> That serio thing is disgusting. We had serious problems with the
> serial driver timeouts for boot-time optimizations too, didn't we?

isn't serio the PS/2 stuff?


(serio was an issue during boot as well due to some interesting rcu
delays btw)


> and none of them look like they should take anywhere close to half a 
> second. So I'm obviously missing something, and your chart didn't
> include the sleep/wakeup pairs.

what do you mean by this? what would you like to see ?
(I have a separate graph for resume.. but the graphing program does not
show those things that take so short to resume that the font to print
the name would be less than a pixel; can fix that)



[fwiw I care more about resume speed than suspend speed, but obviously
am happy if both get fixed... just resume tends to be much more user
interesting, just like getting out of the idle loop matters more than
getting into it]

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
