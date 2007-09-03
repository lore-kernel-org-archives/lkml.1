Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbXICNnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbXICNnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 09:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbXICNno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 09:43:44 -0400
Received: from web32612.mail.mud.yahoo.com ([68.142.207.239]:38661 "HELO
	web32612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751680AbXICNnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 09:43:43 -0400
X-YMail-OSG: iofoFUkVM1mhupsYpJn9joNxX0vHz2rn3igTG6yegjw2jOBB.esS3sFxTAna2456wosf4DDJz8gEdX2tqDUT4xpq2Q--
X-RocketYMMF: knobi.rm
Date: Mon, 3 Sep 2007 06:43:42 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Reply-To: knobi@knobisoft.de
Subject: Re: recent nfs change causes autofs regression
To: Jakob Oestergaard <jakob@unthought.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <20070903132019.GC21977@unthought.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <690844.27749.qm@web32612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jakob Oestergaard <jakob@unthought.net> wrote:

> On Fri, Aug 31, 2007 at 09:43:29AM -0700, Linus Torvalds wrote:
> ...
> > This is *not* a security hole. In order to make it a security hole,
> you 
> > need to be root in the first place.
> 
> Non-root users can write to places where root might believe they
> cannot write
> because he might be under the mistaken assumption that ro means ro.
> 
> I am under the impression that that could have implications in some
> setups.
>

 That was never in question.
 
> ...
> > 
> >  - it's a misfeature that people are used to, and has been around
> forever.
> 
> Sure, they're used it it, but I doubt they are aware of it.
>

 So, the right thing to do (tm) is to make them aware without breaking
their setup. 

 Log any detected inconsistencies in the dmesg buffer and to syslog. If
the sysadmin is not competent enough to notice, to bad.
 
Cheers
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
