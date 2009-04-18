Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZDRTyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZDRTyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 15:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZDRTyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 15:54:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:42978 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752244AbZDRTyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 15:54:13 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18b7pphqfobRtimMXEAT9h3AJup9I6QnQFcG0iK4i
	ouK6VwaoNKtvlL
Date: Sat, 18 Apr 2009 21:54:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: David Miller <davem@davemloft.net>
cc: florian@openwrt.org, peter@holik.at, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
In-Reply-To: <20090418.015541.05303908.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0904182146220.14879@axis700.grange>
References: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at>
 <200904171632.26091.florian@openwrt.org> <Pine.LNX.4.64.0904172102300.5119@axis700.grange>
 <20090418.015541.05303908.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009, David Miller wrote:

> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Date: Fri, 17 Apr 2009 21:07:52 +0200 (CEST)
> 
> > FWIW, I think it's pretty common to name static functions in a .c file, 
> > which perform auxiliary function, not really specific to the context 
> > without the respective context-prefix.
> 
> I'll remember to think of you next time I run grep on the tree.

Thanks David, very nice of you:-)

Once an MMC driver has been submitted for a specific platform, which 
apparently has been derived from an MMC driver for a similar platform. And 
the submitter has preserved the function prefix... So most functions in 
the two drivers were called equally. Now that was bad, and I was the one 
to complain about it, no idea what was the end result with that driver 
though.

What I actually meant is that I don't necessarily consider it very 
inconvenient if different drivers have functions like reg_write() or 
whatever. I cannot think of many situations when this can be confusing. If 
you are working with that file and see a call to reg_write() you know 
where to look for it. If you have an Oops in that function - you just look 
one function up in the backtrace. One of the cases that might be difficult 
is if you have an Oops in such a function without a backtrace and it is in 
a module. Ok, in this case it might be difficult to find out what that 
was. Otherwise - why would you want to grep the sources for such a 
function?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
