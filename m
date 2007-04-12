Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXDLQgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXDLQgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbXDLQgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:36:53 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:38574 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbXDLQgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:36:52 -0400
Date: Thu, 12 Apr 2007 18:36:50 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070412163650.GA19801@uhulinux.hu>
References: <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com> <20070412125412.GA729@uhulinux.hu> <Pine.LNX.4.64.0704121556410.14458@scrub.home> <20070412145822.GA12310@uhulinux.hu> <Pine.LNX.4.64.0704121714280.14457@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704121714280.14457@scrub.home>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 05:52:49PM +0200, Roman Zippel wrote:

> Well, it often doesn't end there, other users may report these as bugs and 
> want to get them fixed, so we have to look ahead a little for possible 
> problems.

They may even report that the current behavior of not knowing anything about
double-width characters is wrong. If Unicode is updated and someone reports
the kernel code is outdated, it's going to be fairly easy to update that one
as well.

I still can't see why my proposed version is by any means worse than the
current one. (I can see however that my version is still not perfect.)

> It has everything to do with this. It describes the terminal capabilities, 
> so why should variable width support not one part of it?

Nice idea. Terminfo database should tell whether a particular terminal
supports double-width characters. Applications should expect the cursor to
move one or two cells depending on this. So both terminfo databases as well
as plenty of libraries and applications would need update. I'll ask Thomas
E. Dickey for his opinion.


-- 
Egmont
