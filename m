Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbXEaXxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbXEaXxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXEaXxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:53:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:51890 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754178AbXEaXxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:53:01 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/G6CxDtsHGwHXGxyOaL5Q1n7V295NhLzzOOXkmN/
	F0PU0u3I6a7Vke
Date: Fri, 1 Jun 2007 01:53:13 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Stephane Casset <sept@logidee.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Something goes wrong with timer statistics.
Message-ID: <20070531235313.GC19353@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Stephane Casset <sept@logidee.com>, linux-kernel@vger.kernel.org
References: <1180474738.22497.25.camel@pi.pomac.com> <20070530001350.GD9086@gromalin.logidee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070530001350.GD9086@gromalin.logidee.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.05.30 02:13:50 +0200, Stephane Casset wrote:
> Le Tue, May 29, 2007 at 11:38:48PM +0200, Ian Kumlien écrivait :
> > Hi, 
> > 
> > As the daystar sets, i try to play some with my new would be
> > firewall/server, but since this will be running for quite some time i
> > have been experimenting with powertop to find out what i can do to limit
> > it's power usage.
> > 
> > But, if i run powertop for too long or a few times to many... this
> > happens:
> > http://pomac.netswarm.net/pics/kernel_panic.jpg
> > 
> > If i don't run powertop, it is rock solid... Compiling for hours,
> > running memtest for hours etc etc... 
> 
> Same here, P4 HT, if I run powertop for 5-10 minutes the system crash :(
> It happens with 2.6.22-rc{2,3} at least :( I didn't try before.
> 
> I don't have a oops since the last crash was in X, but next time I will
> try to catch it. If there is any patch around to fix this I am willing
> to test.

There is finally one that seems to work:
http://lkml.org/lkml/2007/5/31/394

I'd be glad if you could give it a try.

Thanks,
Björn
