Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZL1Xkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZL1Xkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZL1Xka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:40:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36295 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZL1Xk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:40:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Volker Lanz <vl@fidra.de>
Subject: Re: [BISECTED, REGRESSION] Successful resume from suspend but freezes after I/O
Date: Tue, 29 Dec 2009 00:40:53 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
References: <200912071856.48125.vl@fidra.de> <200912080213.20502.vl@fidra.de> <200912210955.00086.vl@fidra.de>
In-Reply-To: <200912210955.00086.vl@fidra.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912290040.53803.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 December 2009, Volker Lanz wrote:
> On Tuesday 08 December 2009 02:13:20 Volker Lanz wrote:
> > On Tuesday 08 December 2009 00:05:11 Yinghai Lu wrote:
> > > the updated e820 table is the same to the one for 2.6.29...
> > >
> > > so could be some other patch cause the problem.
> > >
> > > please check if revert
> > > 2547089ca2db132e307ef68848ba029a8ec2f341
> > > could help.
> > 
> > I reverted to one commit before that, which would be
> > eaa959df299157e2640fcb3321537501b6afd9e6
> > if I am not mistaken. I built and booted that kernel and could reproduce
> >  the freeze with it (TBH this was not surprising to me, because I
> >  originally pinned down the problem by bisecting the commits and this
> >  commit is after the one bisecting found. Am I missing a detail here?)
> > 
> > But strangely enough the freeze this time produced an oops before it locked
> > the machine. I couldn't save it to a file but took a picture. The
> >  screenshot is here:
> > http://banane.volker-lanz.de/08122009013.jpg
> > The oops is _not _reproducable. After a reboot with this same kernel, a
> > suspend/resume cycle and some I/O the machine locks again without showing
> >  the oops.
> > 
> > Volker
> > 
> 
> Any news on this problem? Anything else I can do to help debug the situation? 
> The prospect of being confined to distros with kernels < 2.6.29 for the next 
> couple of years on this machine worries me, obviously.

I have created a Bugzilla entry for this bug at
http://bugzilla.kernel.org/show_bug.cgi?id=14921

Please use it for further tracking of this bug.

Rafael
