Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYCXG6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYCXG6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 02:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbYCXG5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 02:57:54 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35027 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbYCXG5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 02:57:53 -0400
Message-Id: <1206341873.32060.1243929851@webmail.messagingengine.com>
X-Sasl-Enc: 4jERmXGyGedViY6o+Kwdybxqq72rfZ7OTkFLAEY0AECx 1206341873
From: "Kai" <epimetreus@fastmail.fm>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1206310206.17373.1243881033@webmail.messagingengine.com>
   <2c0942db0803231522w7c66f168xf7fea72d135ba395@mail.gmail.com>
Subject: Re: Serious performance regression in Wine applications and Linux
   2.6.24.*
In-Reply-To: <2c0942db0803231522w7c66f168xf7fea72d135ba395@mail.gmail.com>
Date: Sun, 23 Mar 2008 23:57:53 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Mar 23, 2008 at 3:10 PM, Kai <epimetreus@fastmail.fm> wrote:
> > > Kai wrote:
> >  > > Performance degrades by about 60% when I run Wine under any of the
> >  > > 2.6.24.* kernels. Attached are the output of lspci -vv and the two
> >  > > config files of each kernel.
> >  > >
> >  > > I upgraded to 2.6.24, back to 2.6.23.(not sure), then tried 2.6.24.1 and
> >  > > 2.6.24.3 and the issue is present in both; it's severe enough that Wine
> >  > > apps are virtually unusable for me with this version of the kernel; I'm
> >  > > having to use 2.6.23 until this somehow is resolved.
> >  > >
> >  > > I'd like some help figuring out why this performance regression exists,
> >  > > and what can be done to mitigate it.
> >  > >
> >  > > Please CC replies; I'm not on the list.
> >  > >
> >  > This is strange, as my (two) Windows apps ran (and run) just fine under
> >  > 2.6.24 (and now under 2.6.25-rc6). Could you specify the applications
> >  > you're having problems with?
> >
> > Originally, it was just about everything -- Wine itself, and most any
> >  app I tried to run with it.
> >
> >  In my most recent tests, however, it only seems to affect Age of Wonders
> >  II and Age of Wonders Shadow Magic, which use very similar engines.
> 
> What version of X? What version of WINE? Which video driver are you
> using? Does the speed issue show up with glxgears, or something else
> that would be much easier for someone else to reproduce (tuxracer,
> etc.)? Is your system using software or hardware rendering?

The issue only shows with Age of Wonders II and AoW Shadow Magic.

Every version of wine from 0.9.55 to 0.9.58, including several
intermediate git builds.

Xorg version 1.4.0.90, and a couple other versions (the problems has
persisted across a couple updates of Xorg)

Hardware rendering; using the prop. nV driver; updating that also
doesn't affect the issue, nor does retaining the same version.
