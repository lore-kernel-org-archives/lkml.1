Return-Path: <linux-kernel-owner+w=401wt.eu-S965558AbXDLQ5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558AbXDLQ5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965544AbXDLQ5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:57:13 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:58587 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965558AbXDLQ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:57:11 -0400
Date: Thu, 12 Apr 2007 18:55:40 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070412165540.GB21576@uhulinux.hu>
References: <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com> <20070412091120.GA15666@uhulinux.hu> <461E5212.8070807@zytor.com> <Pine.LNX.4.61.0704121840350.14441@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704121840350.14441@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 06:41:22PM +0200, Jan Engelhardt wrote:

> >> I've been thinking on it and I'm not sure which one the right way is. The
> >> reason for choosing this was probably that this way information that is
> >> not
> >> used by the code can be omitted by the compiler.
> >
> > Then let's leave it out of the source.
> 
> I however will put this into my rpm if it works/isstable.

We've arrived at another coding policy :)

There are two possible behaviors, each have pros and cons. HPA prefers one,
while Jan and me would prefer the other. The difference is one function that
contains a large table and an invocation of that function in a small if
branch.

In my latest version of the patch I've put the function itself inside
comments too. So it's not the real compiler, it's the preprocessor that
omits this code for the default behavior. HPA, I hope you don't mind if the
other reasonable behavior is there in the source, within comments. I think
let's make the job easier for those who have a different opinion. Or is it a
completely stupid idea?


-- 
Egmont
