Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbYDJRWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbYDJRWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYDJRV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:21:57 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:41784 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbYDJRV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:21:57 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 10 Apr 2008 10:21:54 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: signalfd() not handling sigqueue() sigval data correctly
In-Reply-To: <cfd18e0f0804100332v5d5d9becqbd0a612ca81abfe8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804101019270.9405@alien.or.mcafeemobile.com>
References: <47FBDF12.8090400@gmail.com>  <Pine.LNX.4.64.0804091256490.6235@alien.or.mcafeemobile.com>
  <cfd18e0f0804092203s33f0ca5as92f47c4db0b0220f@mail.gmail.com>
 <cfd18e0f0804100332v5d5d9becqbd0a612ca81abfe8@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008, Michael Kerrisk wrote:

> On Thu, Apr 10, 2008 at 7:03 AM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
> > Hi Davide,
> >
> > > > I was doing some playing about with signalfd(), and seem to have encountered a
> > > > bug: when a signalfd read() fetches data for a signal that was sent by
> > > > sigqueue(), the data accompanying the signal is not returned.  Instead
> > > > ssi_int/ssi_ptr is zero.
> > >
> > > Michael, can you give the patch below a spin? I tested it on my x86_64 box
> > > and seems to be working fine:
> > >
> > > Got signal 44
> > >   ssi_code= -1
> > >   ssi_pid = 6314
> > >   ssi_uid = 1000
> > >   ssi_int = 123
> > >   ssi_ptr = 7b
> >
> > This works for me on x86-32.  Thanks Davide!
> 
> Davide,
> 
> Are you going to get this pushed into 2.6.26?  I assume we can't get
> it into 2.6.25...

I'll be sending it Andrew-bound today. I dunno where it'll land mainline.


- Davide


