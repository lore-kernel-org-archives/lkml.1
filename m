Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbZBKTgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbZBKTgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 14:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbZBKTf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 14:35:57 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:58439 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbZBKTf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 14:35:56 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 11 Feb 2009 11:35:55 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: mtk.manpages@gmail.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] timerfd add flags check
In-Reply-To: <cfd18e0f0902102042i677322d3t32ccb7d3a8d5659@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902111133410.25076@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902091525590.8503@alien.or.mcafeemobile.com>  <cfd18e0f0902091636p36e12111yd053b9870816d126@mail.gmail.com> <cfd18e0f0902102042i677322d3t32ccb7d3a8d5659@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009, Michael Kerrisk wrote:

> On Tue, Feb 10, 2009 at 1:36 PM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
> > On Tue, Feb 10, 2009 at 12:31 PM, Davide Libenzi
> > <davidel@xmailserver.org> wrote:
> >> Like Michael requested, this patch adds a missing check for valid flags in
> >> timerfd_settime(), and make it return EINVAL in case some extra bits are
> >> set.
> >>
> >> Michael said:
> >> If this is to be any use to userland apps that want to check flag
> >> support (perhaps it is too late already), then the sooner we get it
> >> into the kernel the better: 2.6.29 would be good; earlier stables as
> >> well would be even better.
> >>
> >> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
> >>
> >>
> >> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> >
> > Davide, one question: is the TFD_FLAGS_SET constant below needed?
> 
> Davide, Ping!  I see Andrew already took the patch, which seems to
> define this unnecessary macro.

Yes, Michael! I will post a correction to Andrew. OTOH an un-necessary 
macro defined could even be passed into the lower priority queue, don't 
you think?



- Davide


