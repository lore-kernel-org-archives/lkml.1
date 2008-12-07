Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbYLGRRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbYLGRRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYLGRRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:17:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:43613 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYLGRRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:17:33 -0500
Date: Sun, 7 Dec 2008 09:18:41 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Takashi Iwai <tiwai@suse.de>,
       Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/3] PCI: Rework default handling of suspend
 and resume
Message-ID: <20081207091841.1d460c1a@infradead.org>
In-Reply-To: <200812071439.27712.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0812061324260.13426-100000@netrider.rowland.org>
	<alpine.LFD.2.00.0812062157590.3425@nehalem.linux-foundation.org>
	<alpine.LFD.2.00.0812062201230.3425@nehalem.linux-foundation.org>
	<200812071439.27712.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Dec 2008 14:39:27 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, 7 of December 2008, Linus Torvalds wrote:
> > 
> > On Sat, 6 Dec 2008, Linus Torvalds wrote:
> > > 
> > > And btw, I'm talking suspend, not hibernate. 
> 
> Even as far as hibernation is concerned, I wouldn't _expect_ any BIOS
> to do anything like this as long as we use the ACPI facility to enter
> S4.

there are funky scenarios where the BIOS ends up .. not knowing.
Like

you boot your laptop
you then hot-dock your laptop
then you suspend (say S4)

..
during resume, the bios sees a very different system than it saw before.
I can totally imagine not all of them getting it right, esp if other
OSes would just re-register interrupts
