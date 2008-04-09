Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYDIHGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYDIHGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 03:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYDIHGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 03:06:32 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:57363 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYDIHGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 03:06:32 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 9 Apr 2008 00:06:23 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: signalfd() not handling sigqueue() sigval data correctly
In-Reply-To: <cfd18e0f0804082331q520d335cgb46972d79a257b63@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804090004000.5580@alien.or.mcafeemobile.com>
References: <47FBDF12.8090400@gmail.com>  <Pine.LNX.4.64.0804081636450.28275@alien.or.mcafeemobile.com>
 <cfd18e0f0804082331q520d335cgb46972d79a257b63@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008, Michael Kerrisk wrote:

> On Wed, Apr 9, 2008 at 1:37 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > On Tue, 8 Apr 2008, Michael Kerrisk wrote:
> >
> > > Hi Davide,
> > >
> > > I was doing some playing about with signalfd(), and seem to have encountered a
> > > bug: when a signalfd read() fetches data for a signal that was sent by
> > > sigqueue(), the data accompanying the signal is not returned.  Instead
> > > ssi_int/ssi_ptr is zero.
> >
> > Are you able to fetch those info with, say, sigtimedwait(2)?
> 
> Yes.

Okie, found it. Tomorrow I'll post a patch. Thank you for reporting.



- Davide


