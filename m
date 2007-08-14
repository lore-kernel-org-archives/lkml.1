Return-Path: <linux-kernel-owner+w=401wt.eu-S1763913AbXHNSo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763913AbXHNSo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933254AbXHNSny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:43:54 -0400
Received: from mail.queued.net ([207.210.101.209]:4348 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934018AbXHNSnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:43:52 -0400
Date: Tue, 14 Aug 2007 14:44:52 -0400
From: Andres Salomon <dilinger@queued.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, akpm@linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: +
 serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
 added to -mm tree
Message-Id: <20070814144452.bab796b4.dilinger@queued.net>
In-Reply-To: <200708142023.23994.rjw@sisk.pl>
References: <200708092026.l79KQlDX017864@imap1.linux-foundation.org>
	<20070813142331.9b0774ae.dilinger@queued.net>
	<20070814103939.GJ2900@elf.ucw.cz>
	<200708142023.23994.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007 20:23:23 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, 14 August 2007 12:39, Pavel Machek wrote:
> > Hi!
> > 
> > > Thanks, updated below!
> > > 
> > > 
> > > 
> > > serial: turn serial console suspend a boot rather than compile time option
> > > 
> > > From: Andres Salomon <dilinger@debian.org>
> > > 
> > > Currently, there's a CONFIG_DISABLE_CONSOLE_SUSPEND that allows one to stop
> > > the serial console from being suspended when the rest of the machine goes
> > > to sleep.  This is incredibly useful for debugging power
> > > management-related
> > 
> > Actually, this should not be configurable. We should simply enable
> > console during suspend for consoles that can handle this,
> > automatically.... this patch does just that. I hope I separated it
> > correctly.


I disagree.  I expect that this will break things; I would prefer to keep
it as a configuration option.  If you want to enable it by default, that's
one thing; but give users the option to turn it off.



-- 
Andres Salomon <dilinger@queued.net>
