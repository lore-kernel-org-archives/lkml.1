Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbYDJXGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbYDJXGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbYDJXFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:05:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32786
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755965AbYDJXFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:05:54 -0400
Date: Thu, 10 Apr 2008 16:05:55 -0700 (PDT)
Message-Id: <20080410.160555.89034540.davem@davemloft.net>
To: jesper.juhl@gmail.com
Cc: tilman@imap.cc, lkml@rtr.ca, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <9a8748490804101602g5006db1eq8a192bf067112aeb@mail.gmail.com>
References: <9a8748490804101509l5d043ff8w565dc44dfeaf0072@mail.gmail.com>
	<20080410.154651.101700010.davem@davemloft.net>
	<9a8748490804101602g5006db1eq8a192bf067112aeb@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jesper Juhl" <jesper.juhl@gmail.com>
Date: Fri, 11 Apr 2008 01:02:35 +0200

> On 11/04/2008, David Miller <davem@davemloft.net> wrote:
> > From: "Jesper Juhl" <jesper.juhl@gmail.com>
> >  Date: Fri, 11 Apr 2008 00:09:11 +0200
> >
> >  What people don't get is that this is a situation where the "end node
> >  principle" applies.  When you have limited resources (here:
> >  developers) you don't push the bulk of the burdon upon them.  Instead
> >  you push things out to the resource you have a lot of, the end nodes
> >  (here: users), so that the situation actually scales.
> >
> Again I can''t do anything but agree with you. You are right. When
> it's possible to do the work this way everyone wins.
> I was just trying to say that when it can't be done that way or the
> user won't, then the bug report still has value and still deserves to
> be taken seriously (although it probably goes lower in the pile than
> the bugs where the end users actually do bisect or whatever).

Absolutely.  If, for example, someone has a clean OOPS I usually won't
request a bisect, that's stupid.

However if the OOPS is hard to diagnose, a bisect might be necessary
still.
