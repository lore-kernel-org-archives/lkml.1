Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYCVNGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYCVNGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 09:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYCVNGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 09:06:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:33305 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754028AbYCVNGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 09:06:10 -0400
X-Authenticated: #19095397
X-Provags-ID: V01U2FsdGVkX1/R2Yw4amzRPdy/XYhTjxUkZ3OYs3AWjXrT71BO5S
	mFKMjrq5qsAAgt
From: Bernd Schubert <bernd-schubert@gmx.de>
To: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Subject: Re: deadline unfairness
Date: Sat, 22 Mar 2008 14:06:01 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200803221225.26728.bernd-schubert@gmx.de> <47E4F6F7.40401@gelato.unsw.edu.au>
In-Reply-To: <47E4F6F7.40401@gelato.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803221406.02621.bernd-schubert@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Aron,

On Saturday 22 March 2008, Aaron Carroll wrote:
> Bernd Schubert wrote:
> > Hello,
> >
> > some it seems the deadline scheduler is rather unfair. Below is an
> > example of md-raid6 initialization of md3, md4 and md5. All three
> > md-devices do share the same blockdevices (we have patched md to allow
> > parallel rebuild of shared block devices, since for us the cpu is the
> > bottleneck and not the block device).
> >
> > All rebuilds started basically at the same time, as you can see, md3 is
> > already done and now md4 rebuilds substantially faster than md5.
> > [..]
> > This is basically with a 2.6.22 kernel + lustre + md-backports, but
> > nothing done to the scheduler.
>
> Hi Bernd,
>
> There is a deadline bug in pre-2.6.24 kernels where lower-sector requests
> can starve higher-sector requests; you might be hitting this bug.  It was
> fixed by commit: 6f5d8aa6382eef2b26032c88656270bdae7f0c42

thanks a lot for your help! I will build a new kernel later on today and then 
report back if it helps. Commit dfb3d72a9aa519672c9ae06f0d2f93eccb35482f also 
looks useful...

Thanks again,
Bernd
