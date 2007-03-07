Return-Path: <linux-kernel-owner+w=401wt.eu-S1161078AbXCGHNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161078AbXCGHNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161081AbXCGHNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:13:34 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42426 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161078AbXCGHNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:13:33 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Mar 2007 23:11:49 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
In-Reply-To: <20070307155553.06c82ca1.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
 <20070307155553.06c82ca1.sfr@canb.auug.org.au>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Stephen Rothwell wrote:

> On Tue, 6 Mar 2007 17:36:56 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
> >
> > The read(2) call will read u32 signal numbers that landed over the
> > signalfd. It returns the size of the data copied, or zero if the sighand
> > we are attached to, has been detached.
> 
> So what about signals that the user asked for a siginfo_t to be returned
> with?

O-Ren:   "You didn't think it was gonna be that easy, did you?"
B-Kiddo: "You know, for a second there, yeah, I kinda did."

:)

I could do that, since where I placed the signalfd_notify() I have the 
siginfo. But that is going to make code a little more complex, since the 
simple bitmaks needs to become a queue.



- Davide


