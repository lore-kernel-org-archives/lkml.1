Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZEZSr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZEZSr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbZEZSrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:47:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47288 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613AbZEZSru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:47:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
Date: Tue, 26 May 2009 20:48:12 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, kernel-testers@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <200905260102.29455.rjw@sisk.pl> <200905261730.53041.elendil@planet.nl>
In-Reply-To: <200905261730.53041.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905262048.13325.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009, Frans Pop wrote:
> On Tuesday 26 May 2009, Rafael J. Wysocki wrote:
> > On Monday 25 May 2009, Frans Pop wrote:
> > > Rafael J. Wysocki wrote:
> > > > If you know of any other unresolved regressions from 2.6.29, please
> > > > let me know either and I'll add them to the list.
> > >
> > > It may be worth tracking a possible regression introduced with -rc6
> > > as a result of http://bugzilla.kernel.org/show_bug.cgi?id=13259.
> > >
> > > A new warning that was added in drivers/acpi/processor_throttling.c
> > > (commit 4973b22a: 'ACPI processor: reset the throttling state once
> > > it's invalid') may be triggering in cases where it shouldn't. It
> > > seems to trigger during boot and on 'cat
> > > /proc/acpi/processor/*/throttling'. Otherwise it's probably
> > > relatively harmless.
> > >
> > > See the comments starting at #23 for details.
> >
> > Hmm.  It's really better if you file a separate bug for that with a
> > reference to the previous discussion.
> 
> Done (after doing additional debugging):
> http://bugzilla.kernel.org/show_bug.cgi?id=13389
> 
> Marked as regression and set as blocking for #13070.

Thanks!

Best,
Rafael
