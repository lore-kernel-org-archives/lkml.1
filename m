Return-Path: <linux-kernel-owner+w=401wt.eu-S1761731AbXLQOoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761731AbXLQOoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbXLQOoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:44:13 -0500
Received: from [81.2.110.250] ([81.2.110.250]:54798 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756221AbXLQOoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:44:11 -0500
Date: Mon, 17 Dec 2007 14:36:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Filippos Papadopoulos <psybases@gmail.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: INITIO scsi driver fails to work properly
Message-ID: <20071217143641.760d4162@the-village.bc.nu>
In-Reply-To: <47668A75.7040707@panasas.com>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	<20071217031841.f483e5ac.akpm@linux-foundation.org>
	<20071217130523.7e9c88bb@the-village.bc.nu>
	<47668A75.7040707@panasas.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 16:40:53 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Mon, Dec 17 2007 at 15:05 +0200, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> initio doesn't seem to have a maintainer...
> >>
> >> Are you able to identify any earlier kernel which worked OK?
> >>
> >> Maybe it's a new device?  If you can get the `lspci -vvxx' output
> >> for that device we can take a look.
> > 
> > If I remember rightly the fixes for this went into the scsi tree a couple
> > of months ago. The patch is in the -mm tree as well. No idea why its
> > gotten stuck as an obvious one liner.
> > 
> > Alan
> > -
> You mean this one:
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=ba2c270154cc90c9a8bfc45b7bed4cca78c75aaf
> 
> It's only queued for 2.6.25 via scsi-misc.
> 
> I have found another bug. (See other mail in thread). I Will wait for testing
> and submit a proper patch.

That one yes - which really should have gone straight into the main tree
as the initio driver has been broken all the time it sits queued for
future patches. It can't make the problem any worse - the driver does not
work.
