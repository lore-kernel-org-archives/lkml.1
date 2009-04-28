Return-Path: <linux-kernel-owner+w=401wt.eu-S933324AbZD1RI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324AbZD1RI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933048AbZD1RFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:05:32 -0400
Received: from outbound-mail-157.bluehost.com ([67.222.39.37]:56542 "HELO
	outbound-mail-157.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933060AbZD1RFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:05:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ttsgdMmg8Ga9HWV9vh78/OaCGjCaFLLZdIS89pYbkEkYbs+wHqS6tKVu9/Rcr0zIR4NYQN4nweEJN1vtyhVgqGTrXPqg2V0ETZ/gPAeHbCOiAZn1+4mNYZ1si6f6Hj2A;
Date: Tue, 28 Apr 2009 10:04:21 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Airlie <airlied@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
Message-ID: <20090428100421.5ea15d67@hobbes>
In-Reply-To: <1240903942.7620.68.camel@twins>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>
	<20090427083935.GA20941@elte.hu>
	<1240846843.7620.32.camel@twins>
	<21d7e9970904271854q68242f08pb3f8e12f0ddb6506@mail.gmail.com>
	<1240903942.7620.68.camel@twins>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 09:32:22 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-04-28 at 11:54 +1000, Dave Airlie wrote:
> > On Tue, Apr 28, 2009 at 1:40 AM, Peter Zijlstra
> > <peterz@infradead.org> wrote:
> > > On Mon, 2009-04-27 at 10:39 +0200, Ingo Molnar wrote:
> > >> * Dave Airlie <airlied@gmail.com> wrote:
> > >>
> > >> > Hi guys,
> > >> >
> > >> > I just noticed CONFIG_DRM_I915_KMS is enabled for x86-64.
> > >> >
> > >> > This should never be the case, as anyone who built defconfig
> > >> > kernels before, will now get KMS enabled when really they need
> > >> > to have done userspace upgrades.
> > >>
> > >> I've yet to see such a bugreport.
> > >
> > > Whenever I accidentally enable KMS I get a dead X (happens way
> > > more often that I'd like to), I blame this on the ubuntu Xorg
> > > packages, but can't be arsed to fix it myself -- hopefully the
> > > kinky koala will fix stuff, but who knows.
> > 
> > Well you can't really blame anyone else for it, since you have to
> > put the code upstream
> > in the kernel before you can release drivers that use it for
> > distros to package.
> > 
> > So it would be impossible for any distro to have shipped kms
> > drivers in a useful fashion before KMS is actually in the kernel.
> 
> Can't the driver detect KMS and use it when present? In that case they
> could just ship a KMS capable driver that works either way.
> 
> Anyway, I'm sure it'll all sort itself out.

Yeah Jaunty has such drivers, but Intrepid released with 2.4.x
xf86-video-intel drivers I think, which doesn't have autodetection.

-- 
Jesse Barnes, Intel Open Source Technology Center
