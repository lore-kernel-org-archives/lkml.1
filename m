Return-Path: <linux-kernel-owner+w=401wt.eu-S1750944AbXCWQSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944AbXCWQSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbXCWQSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:18:46 -0400
Received: from nijmegen.renzel.net ([195.243.213.130]:58709 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXCWQSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:18:45 -0400
From: Marcel Siegert <mws@linuxtv.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] DVB: Delete unused header file linux/dvb/version.h.
Date: Fri, 23 Mar 2007 17:18:27 +0100
User-Agent: KMail/1.9.6
Cc: Arjan van de Ven <arjan@infradead.org>, v4l-dvb-maintainer@linuxtv.org,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Andrew Morton <akpm@osdl.org>
References: <Pine.LNX.4.64.0703231130480.30201@CPE00045a9c397f-CM001225dbafb6> <200703231647.53780.mws@linuxtv.org> <1174665764.1158.241.camel@laptopd505.fenrus.org>
In-Reply-To: <1174665764.1158.241.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703231718.28658.mws@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 March 2007, Arjan van de Ven wrote:
> On Fri, 2007-03-23 at 16:47 +0100, Marcel Siegert wrote:
> > On Friday 23 March 2007, Robert P. J. Day wrote:
> > > 
> > > Delete the unreferenced header file include/linux/dvb/version.h.
> > > 
> > > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> > > 
> > NACK
> > this header is unreferenced in kernel, but used for applications that compile for userspace
> > to determine the api version.
> 
> 
> btw that is something extremely evil to do. Either you have varying apis
> between kernels (which is naughty, but I suppose you can go up in
> capabilities) or it's fully static. 
> 
> If it's dynamic, doing it compiletime is BAD. The same binaries should
> run on multiple kernels after all. An ioctl or a sysfs thing or
> something is a lot better than a compile time constant.
> 
> If it's entirely static exposing a "version" doesn't mean anything and
> it might as well be killed...
> 
> Greetings,
>    Arjan van de Ven
 
hi arjan, 

we discussed that topic - an IOCTL to determine the api version - on dvb ml in nov.2005 and
got no result. so this is still there and will stay imho, until we will find a solution.

regards
marcel

