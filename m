Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbXDMJvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbXDMJvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 05:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbXDMJvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 05:51:54 -0400
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:45375 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753000AbXDMJvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 05:51:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=S9fbqEkZ5s/nNcnU7adrOXAgiziaRN/CEAivVWnMDCL0VxgZ6q2TaXaoixNH/dOOfma6KKvf/WxUMr4SVMvZ5enFMXngCP/p0RWrHRroOeyC0/m0/UljGuocv+7ZspA5k0tumWzIyyOiQPz51OoF+yOouSs1AX7TixBbyR4x2+E=  ;
X-YMail-OSG: OkglYAkVM1mIdtdgSgnQ.LdH5bUxvDuhYU6Xksj9_dfseLSr0rvVxLCOp.wu.YPnza3v31aTug--
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH][RFC] Kill off legacy power management stuff.
Date: Fri, 13 Apr 2007 02:51:50 -0700
User-Agent: KMail/1.7.1
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6> <200704131022.45315.rjw@sisk.pl>
In-Reply-To: <200704131022.45315.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704130251.50655.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2007 1:22 am, Rafael J. Wysocki wrote:
> [appropriate CCs added]
> 
> On Friday, 13 April 2007 02:33, Robert P. J. Day wrote:
> > 
> > just something i threw together, not in final form, but it represents
> > tossing the legacy PM stuff.  at the moment, the menuconfig entry for
> > PM_LEGACY lists it as "DEPRECATED", while the help screen calls it
> > "obsolete."  that's a good sign that it's getting close to the time
> > for it to go, and the removal is fairly straightforward, but there's
> > no mention of its removal in the feature removal schedule file.
> 
> It's been like this for a long long time.  I think you're right that it can be
> dropped, but I don't know the details (eg. why it hasn't been dropped yet).

I was just thinking about this the other day.  I did an inventory of
the actual _users_ of this code when I added the deprecation to Kconfig,
and the only driver that would catch the notification was for some
old m68k platform serial driver (Amiga?) ... that won't have changed.

So the only reason not to remove it at that time was to make sure that
folk had a chance to squawk about it going away.  I think it's past
time for this ancient stuff to vanish, since it's been obsolete for
most of 2.5..2.6 and there's only that one event consumer left.

Go for it!

- Dave




