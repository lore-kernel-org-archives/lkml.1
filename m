Return-Path: <linux-kernel-owner+w=401wt.eu-S965109AbXDLQ67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109AbXDLQ67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965529AbXDLQ67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:58:59 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965109AbXDLQ66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:58:58 -0400
Message-ID: <461E653E.6020400@zytor.com>
Date: Thu, 12 Apr 2007 09:58:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Egmont Koblinger <egmont@uhulinux.hu>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
References: <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com> <20070412091120.GA15666@uhulinux.hu> <461E5212.8070807@zytor.com> <Pine.LNX.4.61.0704121840350.14441@yvahk01.tjqt.qr> <20070412165540.GB21576@uhulinux.hu>
In-Reply-To: <20070412165540.GB21576@uhulinux.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Egmont Koblinger wrote:
> 
> We've arrived at another coding policy :)
> 
> There are two possible behaviors, each have pros and cons. HPA prefers one,
> while Jan and me would prefer the other. The difference is one function that
> contains a large table and an invocation of that function in a small if
> branch.
> 
> In my latest version of the patch I've put the function itself inside
> comments too. So it's not the real compiler, it's the preprocessor that
> omits this code for the default behavior. HPA, I hope you don't mind if the
> other reasonable behavior is there in the source, within comments. I think
> let's make the job easier for those who have a different opinion. Or is it a
> completely stupid idea?
> 

Not leaving dead code in the kernel is long-standing policy; it's 
nothing new.  We constantly remove #if 0'd code that the authors have 
left in.

	-hpa
