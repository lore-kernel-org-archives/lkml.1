Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbZBOQt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbZBOQt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 11:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbZBOQtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 11:49:18 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:40938 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZBOQtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 11:49:17 -0500
Date: Sun, 15 Feb 2009 16:48:12 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Jeff Garzik <jeff@garzik.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12609] v2.6.29-rc2 libata sff 32bit PIO regression
In-Reply-To: <4997CDDC.1020103@garzik.org>
Message-ID: <Pine.LNX.4.64.0902151639550.23452@blonde.anvils>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.kkF.Ds0lJB@chimera>
 <499797FD.5070701@lwfinger.net> <4997CDDC.1020103@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Feb 2009, Jeff Garzik wrote:
> Larry Finger wrote:
> > Rafael J. Wysocki wrote:
> > >
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12609
> > > Subject		: v2.6.29-rc2 libata sff 32bit PIO regression
> > > Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> > > Date		: 2009-01-23 23:52 (23 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=123275478111406&w=4
> > > 		  http://marc.info/?l=linux-kernel&m=123254501314058&w=4
> > > Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
> > >     Hugh Dickins <hugh@veritas.com>
> > >     Sergei Shtylyov <sshtylyov@ru.mvista.com>
> > > Patch		:
> > > http://marc.info/?l=linux-kernel&m=123412278730735&w=4
> > 
> > This problem is not fixed as of 2.6.29-rc5.
> 
> Sergei, what is the latest version of your patch?   According to my notes, you
> and Hugh were going back and forth trading patches, and I never saw a final
> version...

I was happy with the patch Sergei posted a week ago, and said so -
except for the question of whether to say "unlikely(slop)": and
that's a very silly little issue which should never have delayed
fixing a significant regression, I'm sorry I ever raised it.

But I was expecting Alan to gather the fixes together and send them
to you: on 26 Jan he posted two other patches, one perhaps just a
cleanup, but the other he said required for correct behaviour on
AMD devices: I thought all three patches would be in by now.

Hugh
