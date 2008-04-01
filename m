Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbYDAVCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbYDAVCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759014AbYDAU7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:59:34 -0400
Received: from mail-07.jhb.wbs.co.za ([196.2.97.4]:17636 "EHLO
	mail-07.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023AbYDAU7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:59:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8EAPI+8kfEAmHEZGdsb2JhbACRPBwpml4
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: 2.6.25-rc regression: bttv: oops on radio access (bisected)
Date: Tue, 1 Apr 2008 22:58:26 +0200
User-Agent: KMail/1.9.9
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Douglas Schilling Landgraf <dougsland@gmail.com>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Morton <akpm@google.com>
References: <20080330162006.GA6048@joi> <20080401171051.724a9f75@gaivota> <20080401205240.GA11485@joi>
In-Reply-To: <20080401205240.GA11485@joi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804012258.27095.bonganilinux@mweb.co.za>
X-Original-Subject: Re: 2.6.25-rc regression: bttv: oops on radio access (bisected)
X-Scan-Signature: 1b59164be252e3c5e2ab2d734b08ae31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008 22:52:45 Marcin Slusarz wrote:
> On Tue, Apr 01, 2008 at 05:10:51PM -0300, Mauro Carvalho Chehab wrote:
> > Hi Marcin
> >
> > On Sun, 30 Mar 2008 18:20:49 +0200
> >
> > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > > Hi
> > > 2.6.25-rc7 kernel oopses on exec of "radio -c /dev/radio0".
> > > I bisected it down to:
> > >
> > > 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b is first bad commit
> > > commit 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b
> > > Author: Douglas Schilling Landgraf <dougsland@gmail.com>
> > > Date:   Thu Dec 27 22:20:58 2007 -0300
> > >
> > >     V4L/DVB (6911): Converted bttv to use video_ioctl2
> > >
> > >     Signed-off-by: Douglas Schilling Landgraf <dougsland@gmail.com>
> > >     Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> >
> > There are three patches that are meant to fix the bugs with radio. On the
> > tests I did here, they worked, but the Bongani still points that the
> > fixes didn't solve for him.
> >
> > On the tests I did here, the three patches seemed to work [1]. Maybe you
> > could test with those patches and post us some results.
> >
> > There are three patches meant to fix several issues caused by the
> > conversion:
> >
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdif
> >f;h=bdd38d9b5c6365ea004df6d8a183dd1344b4801f
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdif
> >f;h=055a6282cabd311cf010a5a83f0494558504f7d0
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdif
> >f;h=6e07ff78274752fe812a1e8bddb6013a278e62e8
> >
> > Could you test please and give us some feedback?
>
> These patches fix my regression. Thanks!
> (no oops, radio app does not crash/hang, no messages about invalid ioctls,
> i can hear the radio)
>
> Marcin

When you exit the radio application do you get an oops? And does your TV work 
with those patches? Those were the two issues I had.


