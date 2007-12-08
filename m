Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbXLHV6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbXLHV6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 16:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXLHV6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 16:58:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbXLHV6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 16:58:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Date: Sat, 8 Dec 2007 23:17:46 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?q?M=E1rton_N=E9meth?= <nm127@freemail.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071208012922.adb70db2.akpm@linux-foundation.org>
In-Reply-To: <20071208012922.adb70db2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712082317.47040.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 8 of December 2007, Andrew Morton wrote:
> On Sat, 8 Dec 2007 03:40:49 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message contains a list of some regressions from 2.6.23 which have been
> > reported since 2.6.24-rc1 was released and for which there are no fixes in the
> > mainline that I know of.  If any of them have been fixed already, please let me
> > know.
> > 
> > If you know of any other unresolved regressions from 2.6.23, please let me know
> > either and I'll add them to the list.
> 
> Twenty nine, huh?
> 
> It would be useful if these records were sorted in date-of-reportage order
> and had a date stamp so we could see how long they've been hanging about.

They are sorted by the bugzilla number which reflects the date-of-reportage
order pretty well.  For a techincal reason, it's easier to me if they're sorted
like this.

Adding date stamps should be easy, tough, I'll try to add them to the next
report.

> Something to think about for the post-2.6.24 regression if you'll be handling
> those?

Yes, I'm going to handle the post-2.6.24 regressions too (in the hope there
will be less of them ;-)).

> > Subject		: leds: ledtrig-timer calls sleeping function from invalid context
> > Submitter	: Márton Németh <nm127@freemail.hu>
> > References	: http://bugzilla.kernel.org/show_bug.cgi?id=9264
> > Handled-By	: Richard Purdie <rpurdie@rpsys.net>
> > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13493&action=view
> 
> That patch has been merged (dc47206e552c0850ad11f7e9a1fca0a3c92f5d65) and
> assuming Márton has tested the latest git snapshot
> (ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots) successfully we can
> cross it off?

Yes, will drop.

Thanks,
Rafael
