Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192Ab0A0WNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0A0WNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184Ab0A0WNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:13:13 -0500
Received: from www17.your-server.de ([213.133.104.17]:52574 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab0A0WNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:13:09 -0500
Subject: Re: [Bug #14670] i915: playing video via XVideo extension makes
 the screen flicker
From: Thomas Meyer <thomas@m3y3r.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
In-Reply-To: <20100127095940.07e205ba@jbarnes-piketon>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	 <q60Z28d_9yH.A.fTB.-aMXLB@chimera>
	 <20100127095940.07e205ba@jbarnes-piketon>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 23:12:16 +0100
Message-ID: <1264630336.3326.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 27.01.2010, 09:59 -0800 schrieb Jesse Barnes:
> On Sun, 24 Jan 2010 23:22:54 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14670
> > Subject		: i915: playing video via XVideo extension makes the screen flicker
> > Submitter	: Thomas Meyer <thomas@m3y3r.de>
> > Date		: 2009-11-23 13:15 (63 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b42d4c5c6a872815d711e5d51a600f5122c38eee
> > References	: http://lkml.org/lkml/2010/1/11/150
> > 
> 
> this one may also be fixed by David's patch if -rc5 doesn't already fix
> it.

Still see this error with -rc5. But I guess this is very likely an
ACPI/BIOS error. I have an Acer 1810T (1410T in US of A) with BIOS
version 3302. Can someone with the same hardware but different (i.e.
newer BIOS version - version 3303) confirm this bug?

When the flickering occurs, switching VTs back and forth makes the
problem go away!

greets
thomas


