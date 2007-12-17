Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbXLQPrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbXLQPrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbXLQPrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:47:13 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:48023 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbXLQPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:47:12 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 17 Dec 2007 07:47:05 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, tytso@thunk.org,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       Christoph Hellwig <hch@lst.de>,
       Linux Torvalds <torvalds@linux-foundation.org>
Subject: Re: Tesing of / bugs in new timerfd API
In-Reply-To: <cfd18e0f0712170527k6e2f20ddq8d3abc367aa20661@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0712170745220.10244@alien.or.mcafeemobile.com>
References: <47614369.3060906@gmail.com>  <Pine.LNX.4.64.0712131333030.10881@alien.or.mcafeemobile.com>
  <cfd18e0f0712131416y6159af46v6d0c91d75130cd69@mail.gmail.com> 
 <Pine.LNX.4.64.0712131603010.10881@alien.or.mcafeemobile.com> 
 <4762683D.8050007@gmail.com>  <Pine.LNX.4.64.0712161210120.14339@alien.or.mcafeemobile.com>
 <cfd18e0f0712170527k6e2f20ddq8d3abc367aa20661@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007, Michael Kerrisk wrote:

> > Can you try the two patches below? I tried them on my 32 bit box (one of
> > the rare beasts still lingering around here) and it seems to be working
> > fine (those go on top of the previous ones).
> 
> Against 2.6.24-rc5, I applied first your earlier patches ("v3") and
> then the newest patch.  My tests confirm that:
> 
> > This fixed the 32 bit tick-count truncation, and makes the time returned
> > to be the remaining time till the next expiration.
> 
> Are you going to resubmit a new patch set that includes these latest changes?

Yes, I'll send them out to Andrew today.


- Davide


