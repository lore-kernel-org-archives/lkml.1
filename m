Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZFVGmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZFVGmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 02:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZFVGmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 02:42:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:50170 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZFVGmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:42:36 -0400
Date: Sun, 21 Jun 2009 23:43:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [patch update 2 fix] PM: Introduce core framework
 for  run-time PM of I/O devices
Message-ID: <20090621234324.06fda564@infradead.org>
In-Reply-To: <aec7e5c30906212320v3e3e991fyd028d005675f1e25@mail.gmail.com>
References: <Pine.LNX.4.44L0.0906192141380.4003-100000@netrider.rowland.org>
	<Pine.LNX.4.44L0.0906201010590.12994-100000@netrider.rowland.org>
	<aec7e5c30906212320v3e3e991fyd028d005675f1e25@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 15:20:43 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

> On Sat, Jun 20, 2009 at 11:30 PM, Alan
> Stern<stern@rowland.harvard.edu> wrote:
> > Some more thoughts...
> >
> > Magnus, you might have some insights here.  It occurred to me that
> > some devices can switch power levels very quickly, and the drivers
> > might therefore want the runtime suspend and resume methods to be
> > called as soon as possible, even in interrupt context.
> 
> I'd like to call pm_request_suspend() from interrupt context. I don't

there are some really strong reasons to at least be able to call the
resume function from an interrupt handler.... shared interrupts are one
of them.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
