Return-Path: <linux-kernel-owner+w=401wt.eu-S1761205AbZBXWLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761205AbZBXWLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760006AbZBXWLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:11:16 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:42367 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759159AbZBXWLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:11:14 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <49A3E38F.7080306@redhat.com>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>
	 <LLno3yT_fnC.A.-RH.ZzzoJB@chimera>
	 <1235437183.4988.2.camel@kulgan.wumi.org.au>  <49A3E38F.7080306@redhat.com>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Wed, 25 Feb 2009 08:41:06 +1030
Message-Id: <1235513466.4860.7.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 14:09 +0200, Avi Kivity wrote:
> Kevin Shanahan wrote:
> > On Mon, 2009-02-23 at 23:03 +0100, Rafael J. Wysocki wrote:
> >   
> >> This message has been generated automatically as a part of a report
> >> of regressions introduced between 2.6.27 and 2.6.28.
> >>
> >> The following bug entry is on the current list of known regressions
> >> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> >> be listed and let me know (either way).
> >>     
> >
> > Yes, the problem should still be listed.
> > The bug is still present as recently as 2.6.29-rc5-00299-gadfafef.
> >   
> 
> Did tracing turn anything up?

I provided some more traces using Ingo's "tip" branch, but I don't think
anyone has looked at them yet.

  http://bugzilla.kernel.org/show_bug.cgi?id=12465#c11

I can provide more traces if e.g. a different set of functions is
required, but I'm not going to be able to analyse them properly myself.

I should have a bit more time for testing next week and I plan to try
setting up the guest with the different virtual network adapters models
to see if that helps.

Cheers,
Kevin.


