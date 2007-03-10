Return-Path: <linux-kernel-owner+w=401wt.eu-S1767704AbXCJBC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767704AbXCJBC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767706AbXCJBC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:02:57 -0500
Received: from mail20.syd.optusnet.com.au ([211.29.132.201]:49903 "EHLO
	mail20.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767704AbXCJBC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:02:56 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sat, 10 Mar 2007 12:02:25 +1100
User-Agent: KMail/1.9.5
Cc: Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <20070309215716.GK943@1wt.eu> <200703100912.07792.kernel@kolivas.org>
In-Reply-To: <200703100912.07792.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703101202.25814.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 09:12, Con Kolivas wrote:
> On Saturday 10 March 2007 08:57, Willy Tarreau wrote:
> > On Fri, Mar 09, 2007 at 03:39:59PM -0600, Matt Mackall wrote:
> > > On Sat, Mar 10, 2007 at 08:19:18AM +1100, Con Kolivas wrote:
> > > > On Saturday 10 March 2007 08:07, Con Kolivas wrote:
> > > > > On Saturday 10 March 2007 07:46, Matt Mackall wrote:

> > > 5x memload: good
> > > 5x execload: good
> > > 5x forkload: good
> > > 5 parallel makes: mostly good
> > > make -j 5: bad
> > >
> > > So what's different between makes in parallel and make -j 5? Make's
> > > job server uses pipe I/O to control how many jobs are running.
> >
> > Matt, could you check with plain 2.6.20 + Con's patch ? It is possible
> > that he added bugs when porting to -mm, or that someting in -mm causes
> > the trouble. Your experience with -mm seems so much different from mine
> > with mainline, there must be a difference somewhere !
>
> Good idea.

It's all very odd Matt. It really isn't behaving anything like you describe 
for myself or others. It sounds more like a real bug than what the design 
would do at all. The only things that are different on yours is Beryl and a 
different graphics card. When you're comparing to mainline are you 
comparing -mm1 to -mm2 to ensure something else from -mm isn't responsible? 
Also have you tried rsdl on 2.6.20 as Willy suggested? I would really love to 
get to the bottom of this as it really shouldn't behave that way under load 
no matter how the load is dished out.

Thanks!

-- 
-ck
