Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbZHZUw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbZHZUw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZHZUw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:52:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZHZUw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:52:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
Date: Wed, 26 Aug 2009 22:53:47 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Rientjes <rientjes@google.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Larry Finger <Larry.Finger@lwfinger.net>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera> <Cg6cQYLdUxG.A.K-C.U2GlKB@chimera> <84144f020908252325p88178f2yb0a76e033352b78d@mail.gmail.com>
In-Reply-To: <84144f020908252325p88178f2yb0a76e033352b78d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908262253.47651.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Pekka Enberg wrote:
> Hi Rafael,
> 
> On Wed, Aug 26, 2009 at 12:05 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13319
> > Subject         : Page allocation failures with b43 and p54usb
> > Submitter       : Larry Finger <Larry.Finger@lwfinger.net>
> > Date            : 2009-04-29 21:01 (119 days old)
> > References      : http://marc.info/?l=linux-kernel&m=124103897101088&w=4
> >                  http://lkml.org/lkml/2009/6/7/136
> >                  http://lkml.org/lkml/2009/7/26/213
> > Handled-By      : Johannes Berg <johannes@sipsolutions.net>
> >                  David Rientjes <rientjes@google.com>
> > Patch           : http://patchwork.kernel.org/patch/37655/
> 
> FYI, the fix (a new slub debugging option) is queued for 2.6.32 and we
> don't have plans to backport it to -stable because it depends on SLUB
> out-of-memory diagnostic patches and the problem doesn't affect
> production configs.

Thanks for the info, I've closed the bug as "will fix later".

Rafael
