Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbZD1Hct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbZD1Hct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZD1Hci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:32:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:54561 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410AbZD1Hci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:32:38 -0400
Subject: Re: kms in defconfig
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <21d7e9970904271854q68242f08pb3f8e12f0ddb6506@mail.gmail.com>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>
	 <20090427083935.GA20941@elte.hu> <1240846843.7620.32.camel@twins>
	 <21d7e9970904271854q68242f08pb3f8e12f0ddb6506@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Apr 2009 09:32:22 +0200
Message-Id: <1240903942.7620.68.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 11:54 +1000, Dave Airlie wrote:
> On Tue, Apr 28, 2009 at 1:40 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2009-04-27 at 10:39 +0200, Ingo Molnar wrote:
> >> * Dave Airlie <airlied@gmail.com> wrote:
> >>
> >> > Hi guys,
> >> >
> >> > I just noticed CONFIG_DRM_I915_KMS is enabled for x86-64.
> >> >
> >> > This should never be the case, as anyone who built defconfig
> >> > kernels before, will now get KMS enabled when really they need to
> >> > have done userspace upgrades.
> >>
> >> I've yet to see such a bugreport.
> >
> > Whenever I accidentally enable KMS I get a dead X (happens way more
> > often that I'd like to), I blame this on the ubuntu Xorg packages, but
> > can't be arsed to fix it myself -- hopefully the kinky koala will fix
> > stuff, but who knows.
> 
> Well you can't really blame anyone else for it, since you have to put
> the code upstream
> in the kernel before you can release drivers that use it for distros to package.
> 
> So it would be impossible for any distro to have shipped kms drivers in a useful
> fashion before KMS is actually in the kernel.

Can't the driver detect KMS and use it when present? In that case they
could just ship a KMS capable driver that works either way.

Anyway, I'm sure it'll all sort itself out.


