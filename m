Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbXLGXqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbXLGXqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXLGXqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:46:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:44482 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751923AbXLGXqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:46:32 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+dU6hJrWOdL7IGK3V0XnKyLk4mY7Kte2IUtafeBs
	xC5gVu4YyG6pet
Date: Sat, 8 Dec 2007 00:46:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Markus <M4rkusXXL@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: programs vanish with 2.6.22+
In-Reply-To: <200712072352.04454.M4rkusXXL@web.de>
Message-ID: <Pine.LNX.4.64.0712080043360.847@axis700.grange>
References: <200712061906.42070.M4rkusXXL@web.de> <200712071240.27838.M4rkusXXL@web.de>
 <Pine.LNX.4.64.0712071252040.29411@axis700.grange> <200712072352.04454.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007, Markus wrote:

> Well, now some windows vanished, but no additional messages were 
> produced by kernel. When somebody could tell what I exactly need to 
> do... would be nice.
> Or a hit, in what direction I should look. Because its really nasty to 
> not being able to use a current kernel.
> 
> I already rebuild the whole system, as suggested by the gentoo-devs, 
> without success.
> 
> I could also try to debug/strace/whatever the apps and wait for it to 
> disappear.

Well, you could attach strace to all likely crash candidates like

strace -etrace=none -o/tmp/<pid>.trace -p<pid>

which would at least tell you what signal it caught...

good luck
Guennadi

> 
> Just talk to me, I am not able to do this on my own...
> 
> 
> Markus
> 
> > On Fri, 7 Dec 2007, Markus wrote:
> > 
> > > Hi again!
> > > 
> > > The memtest ran 14 passes (~10h) without an error.
> > > 
> > > I now have a 2.6.24-rc4 with some debug-options turned on, waiting 
> for 
> > > something to happen... can I just leave it untill a window 
> disappears 
> > > or do I need to manually enable something or run some user-space 
> app?!
> > 
> > It depends - different options have it differently. Most simple ones 
> are 
> > just compile-time, so, you don't have to enable them. Look in "help" 
> for 
> > respective debug-options.
> > 
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski
> > 
> 
> 

---
Guennadi Liakhovetski
