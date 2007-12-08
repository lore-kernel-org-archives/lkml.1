Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbXLHMbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbXLHMbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 07:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbXLHMa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 07:30:59 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:38624 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbXLHMa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 07:30:58 -0500
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: programs vanish with 2.6.22+
Date: Sat, 8 Dec 2007 13:25:21 +0100
User-Agent: KMail/1.9.7
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <200712061906.42070.M4rkusXXL@web.de> <200712072352.04454.M4rkusXXL@web.de> <Pine.LNX.4.64.0712080043360.847@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0712080043360.847@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712081325.21790.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1+DZVsKDUVhqw3X2z28T39+IJp4TXIG7tVVDN1Q
	yF/qv1Nw4QFXyQB5S6BjNKp+54Cau1z7M4HmgYH1Dp/yrIR/3K
	An5q/RULM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, just tried it. Started a dozen konquerors and attached strace to 
everyone. When one disapeared, I only got a "Process 9246 detached", 
nothing else is printed or written in the log.

Markus


> On Fri, 7 Dec 2007, Markus wrote:
> 
> > Well, now some windows vanished, but no additional messages were 
> > produced by kernel. When somebody could tell what I exactly need to 
> > do... would be nice.
> > Or a hit, in what direction I should look. Because its really nasty 
to 
> > not being able to use a current kernel.
> > 
> > I already rebuild the whole system, as suggested by the gentoo-devs, 
> > without success.
> > 
> > I could also try to debug/strace/whatever the apps and wait for it 
to 
> > disappear.
> 
> Well, you could attach strace to all likely crash candidates like
> 
> strace -etrace=none -o/tmp/<pid>.trace -p<pid>
> 
> which would at least tell you what signal it caught...
> 
> good luck
> Guennadi
> 
> > 
> > Just talk to me, I am not able to do this on my own...
> > 
> > 
> > Markus
> > 
> > > On Fri, 7 Dec 2007, Markus wrote:
> > > 
> > > > Hi again!
> > > > 
> > > > The memtest ran 14 passes (~10h) without an error.
> > > > 
> > > > I now have a 2.6.24-rc4 with some debug-options turned on, 
waiting 
> > for 
> > > > something to happen... can I just leave it untill a window 
> > disappears 
> > > > or do I need to manually enable something or run some user-space 
> > app?!
> > > 
> > > It depends - different options have it differently. Most simple 
ones 
> > are 
> > > just compile-time, so, you don't have to enable them. Look 
in "help" 
> > for 
> > > respective debug-options.
> > > 
> > > Thanks
> > > Guennadi
> > > ---
> > > Guennadi Liakhovetski
> > > 
> > 
> > 
> 
> ---
> Guennadi Liakhovetski
> 


