Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbXHXKrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbXHXKrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbXHXKrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:47:07 -0400
Received: from web32613.mail.mud.yahoo.com ([68.142.207.240]:37615 "HELO
	web32613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754375AbXHXKrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:47:06 -0400
X-YMail-OSG: HlGCtOAVM1ks3wX4w5Zd0v36f1bpG3VGG17nJWDTNm7FMnnkCE54iMignq.A835KYWb9LlCpn7JB8l2iVD_zgYjZyw--
X-RocketYMMF: knobi.rm
Date: Fri, 24 Aug 2007 03:47:03 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: RE: [PATCH 00/23] per device dirty throttling -v9
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1187890919.6114.411.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <681242.83596.qm@web32613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2007-08-23 at 08:59 -0700, Martin Knoblauch wrote:
> > --- Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Thu, 2007-08-16 at 05:49 -0700, Martin Knoblauch wrote:
> > > 
> > > > Peter,
> > > > 
> > > >  any chance to get a rollup against 2.6.22-stable?
> > > > 
> > > >  The 2.6.23 series may not be usable for me due to the
> > > > nosharedcache changes for NFS (the new default will massively
> > > > disturb the user-space automounter).
> > > 
> > > I'll see what I can do, bit busy with other stuff atm, hopefully
> > > after
> > > the weekend.
> > > 
> > Hi Peter,
> > 
> >  any progress on a version against 2.6.22.5? I have seen the very
> > positive report from Jeffrey W. Baker and would really love to test
> > your patch. But as I said, anything newer than 2.6.22.x might not
> be an
> > option due to the NFS changes.
> 
> mindless port, seems to compile and boot on my test box ymmv.
> 
> I think .5 should not present anything other than trivial rejects if
> anything. But I'm not keeping -stable in my git remotes so I can't
> say
> for sure.

Hi Peter,

 thanks a lot. It applies to 2.6.22.5 almost cleanly, with just one
8-line offset in readahead.c.

 I will report testing-results separately.

Thanks
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
