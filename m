Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbZC3Sos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbZC3Sos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbZC3Soj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:44:39 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40542 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbZC3Soi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:44:38 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Subject: Re: 2.6.29 on MacBook 2,1 fails to reboot
Date: Mon, 30 Mar 2009 19:44:29 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-damocles; KDE/4.2.1; x86_64; ; )
Cc: "Morten P.D. Stevens" <mstevens@win-professional.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <9b1675090903291904g7eca965eydb1aa3f852a1b91c@mail.gmail.com> <200903301357.17076.alistair@devzero.co.uk> <9b1675090903300826s2ce361e5s1134e13507b0399@mail.gmail.com>
In-Reply-To: <9b1675090903300826s2ce361e5s1134e13507b0399@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903301944.30030.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009 16:26:13 Trenton D. Adams wrote:
> On Mon, Mar 30, 2009 at 6:57 AM, Alistair John Strachan
>
> <alistair@devzero.co.uk> wrote:
> > On Monday 30 March 2009 08:33:06 Trenton D. Adams wrote:
> >> And, if I mark the 2.6.27 one as bad, it just remains on 2.6.27.
> >
> > Don't worry about the kernel version it generates. Git bisections
> > traverse merged branches, including those that weren't rebased before
> > being merged (in fact the preferred work flow). I usually add "-bisect"
> > to CONFIG_LOCALVERSION so I can isolate my work in progress bisection
> > from system kernels.
> >
> > You can trust git to involve only relevant commits between your initial
> > "good" and "bad" markers; don't add more unless you have to. Sometimes
> > you may need to "shift" the bisection midpoint if you encounter build
> > breakage. You should be able to find comments Linus made on the subject
> > by searching the LKML archive for "git bisect visualize".
> >
> > --
> > Cheers,
> > Alistair.
>
> Okay, so are you saying that switching back to 2.6.27 is okay, because
> the patch that caused this problem may have been created in 2.6.27 (as
> a patch to the released version perhaps), not applied to 2.6.28, and
> then applied to 2.6.29?

Yes. Give "gitk" a shot with your revision ID, it should be quite 
illuminating.

-- 
Cheers,
Alistair.
