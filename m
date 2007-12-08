Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbXLHPtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbXLHPtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbXLHPt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:49:27 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3589 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750991AbXLHPt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:49:27 -0500
Date: Sat, 8 Dec 2007 10:49:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
In-Reply-To: <20071208014638.c4cddf12.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0712081043330.28689-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007, Andrew Morton wrote:

> On Sat, 8 Dec 2007 03:40:49 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message contains a list of some regressions from 2.6.23 which have been
> > reported since 2.6.24-rc1 was released and for which there are no fixes in the
> > mainline that I know of.  If any of them have been fixed already, please let me
> > know.
> > 
> > If you know of any other unresolved regressions from 2.6.23, please let me know
> > either and I'll add them to the list.
> > 
> > 
> > ..
> >
> > Subject		: system hangs after a few minutes
> > Submitter	: Marcus Better <marcus@better.se>
> > References	: http://bugzilla.kernel.org/show_bug.cgi?id=9335
> > Handled-By	: Andrew Morton <akpm@linux-foundation.org>
> > 		  Alan Stern <stern@rowland.harvard.edu>
> > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13871&action=view
> > 
> 
> This one we have a confirmed fix from Alan but it doesn't appear to be in
> anyone's tree.

An expanded version of that fix is in Greg's queue:

http://marc.info/?l=linux-usb-devel&m=119697043410947&w=2

Since he's away until Tuesday, nothing will happen for a few days.  
However you might want to replace the old fix that got added to -mm.

> There is a second bug in here, applicable to core x86: Marcus's machine
> won't boot with nmi_watchdog=1.

Alan Stern

