Return-Path: <linux-kernel-owner+w=401wt.eu-S934022AbXHORIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022AbXHORIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbXHORIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:08:32 -0400
Received: from smtp121.sbc.mail.re3.yahoo.com ([66.196.96.94]:44376 "HELO
	smtp121.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754917AbXHORIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:08:31 -0400
X-YMail-OSG: 7wzXtHQVM1mF4ApDoVT5Sja28Xd0Wbo7XyjFp.gvbfgF09DMcnnexRjyVv1x6fktiBFL1SPEUw--
Date: Wed, 15 Aug 2007 12:08:26 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <clameter@sgi.com>, bob.picco@hp.com, nacc@us.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, mel@skynet.ie,
       akpm@linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
Message-ID: <20070815170826.GA13286@vino.hallyn.com>
References: <20070814192306.GB32553@vino.hallyn.com> <20070814204951.GA2065@vino.hallyn.com> <Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com> <1187127685.6281.139.camel@localhost> <Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com> <1187185392.5422.13.camel@localhost> <20070815143125.GA11582@vino.hallyn.com> <1187195028.5422.30.camel@localhost> <20070815163142.GA12850@vino.hallyn.com> <20070815165234.GC1179@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815165234.GC1179@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dhaval Giani (dhaval@linux.vnet.ibm.com):
> Hi,
> 
> On Wed, Aug 15, 2007 at 11:31:42AM -0500, Serge E. Hallyn wrote:
> > Quoting Lee Schermerhorn (Lee.Schermerhorn@hp.com):
> > > On Wed, 2007-08-15 at 09:31 -0500, Serge E. Hallyn wrote:
> > > > Quoting Lee Schermerhorn (Lee.Schermerhorn@hp.com):
> > > > > On Tue, 2007-08-14 at 14:56 -0700, Christoph Lameter wrote:
> > > > > > On Tue, 14 Aug 2007, Lee Schermerhorn wrote:
> > > > > > 
> > Ok, I'll try this soon as I have a chance.  To be honest when I first
> > looked at this and saw that node_states[] was only being initialized
> > for the first two entries this was my first instinct, except I had
> > no idea what the right way to initilaize it was :)  Cause I am
> > completely numa-challenged.
> >
> 
> I just tried it out and it is not triggering the bug. So i guess it
> works :).

Great, thanks for checking.

I vote let's go with Lee's patch, then.

-serge
