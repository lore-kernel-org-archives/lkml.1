Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbYDXXlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbYDXXlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYDXXk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:40:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYDXXk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:40:57 -0400
Date: Thu, 24 Apr 2008 20:39:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <bphilips@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>, Matthias Schwarzott <zzam@gentoo.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       Patrick Boettcher <pb@linuxtv.org>
Subject: Re: [v4l-dvb-maintainer] no help text for DVB_TUNER_ITD1000
Message-ID: <20080424203937.0c21093b@gaivota>
In-Reply-To: <20080424210821.GA14416@plankton>
References: <20080424202257.GC18854@cs181133002.pp.htv.fi>
	<20080424172838.5df1da67@gaivota>
	<20080424210821.GA14416@plankton>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 14:08:21 -0700
Brandon Philips <bphilips@suse.de> wrote:

> On 17:28 Thu 24 Apr 2008, Mauro Carvalho Chehab wrote:
> > On Thu, 24 Apr 2008 23:22:57 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> > > The DVB_TUNER_ITD1000 option introduced by
> > > commit 1881ee89e0fe03ac5bba9045acb3bea1818f9466
> > > (V4L/DVB (7571): mt312: Cleanup buffer variables of read/write functions)
> > > lacks a help text.
> > > 
> > > Please add a help text.
> > 
> > Thanks for pointing.
> > 
> > I just noticed and prepared a patch. I should soon add it to devel branch
> > at -git for people to review. 
> 
> How is adding this Kconfig related to the patch that Matthias posted?
> Once again, some very strange folding is happening as things are moving
> into git.
> 
> http://article.gmane.org/gmane.linux.drivers.dvb/41017/match=mt312+cleanup+buffer+variables+read+write+functions
> 
> vs.
> 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=1881ee89e0fe03ac5bba9045acb3bea1818f9466;hp=dbad108bdcb30629c850f5606949510da010a686

I didn't understood what happened. some chunks from patch 7569 were wrongly merged on 7571.

I suspect that it is a trouble on my local copy of the -git tree. git fsck is
generating 3434 lines of errors.

I've did a diff between the applied patch and the original ones. It is not easy
to compare the diffs manually, since file order changes, but it seems that the
other patches are ok.

I'll just drop this -git and create another replica.

Matthias, Patrick and others,

sorry for the mess.

Cheers,
Mauro
