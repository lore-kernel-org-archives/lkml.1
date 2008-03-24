Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbYCXQos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbYCXQos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYCXQok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:44:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:55613 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754333AbYCXQoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:44:39 -0400
X-Authenticated: #19095397
X-Provags-ID: V01U2FsdGVkX1+ApV1cmIiA7cmjSLh/TXgeTogz1ffDkNkIvpjVHB
	gAbY98MMhq7mVG
From: Bernd Schubert <bernd-schubert@gmx.de>
To: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Subject: Re: deadline unfairness
Date: Mon, 24 Mar 2008 17:44:35 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200803221225.26728.bernd-schubert@gmx.de> <47E4F6F7.40401@gelato.unsw.edu.au> <200803221406.02621.bernd-schubert@gmx.de>
In-Reply-To: <200803221406.02621.bernd-schubert@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803241744.35298.bernd-schubert@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Aron,

On Saturday 22 March 2008, Bernd Schubert wrote:
> Hello Aron,
>
> On Saturday 22 March 2008, Aaron Carroll wrote:
> > Bernd Schubert wrote:
> > > Hello,
> > >
> > > some it seems the deadline scheduler is rather unfair. Below is an
> > > example of md-raid6 initialization of md3, md4 and md5. All three
> > > md-devices do share the same blockdevices (we have patched md to allow
> > > parallel rebuild of shared block devices, since for us the cpu is the
> > > bottleneck and not the block device).
> > >
> > > All rebuilds started basically at the same time, as you can see, md3 is
> > > already done and now md4 rebuilds substantially faster than md5.
> > > [..]
> > > This is basically with a 2.6.22 kernel + lustre + md-backports, but
> > > nothing done to the scheduler.
> >
> > Hi Bernd,
> >
> > There is a deadline bug in pre-2.6.24 kernels where lower-sector requests
> > can starve higher-sector requests; you might be hitting this bug.  It was
> > fixed by commit: 6f5d8aa6382eef2b26032c88656270bdae7f0c42
>
> thanks a lot for your help! I will build a new kernel later on today and
> then report back if it helps. Commit
> dfb3d72a9aa519672c9ae06f0d2f93eccb35482f also looks useful...

After applying both patches it looks much better now.


Thanks again for your help,
Bernd


