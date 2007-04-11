Return-Path: <linux-kernel-owner+w=401wt.eu-S1750755AbXDKIV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750755AbXDKIV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXDKIV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:21:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43568
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbXDKIVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:21:25 -0400
Date: Wed, 11 Apr 2007 01:21:25 -0700 (PDT)
Message-Id: <20070411.012125.73216651.davem@davemloft.net>
To: schwidefsky@googlemail.com
Cc: akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@linux-foundation.org, heiko.carstens@de.ibm.com
Subject: Re: link error : 2.6.21-rc6-mm1 for s390
From: David Miller <davem@davemloft.net>
In-Reply-To: <6e0cfd1d0704110115j1153e4ecn3725e7787233e0e2@mail.gmail.com>
References: <20070410.221101.110908614.davem@davemloft.net>
	<20070410233919.0fa4894e.akpm@linux-foundation.org>
	<6e0cfd1d0704110115j1153e4ecn3725e7787233e0e2@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Martin Schwidefsky" <schwidefsky@googlemail.com>
Date: Wed, 11 Apr 2007 10:15:42 +0200

> On 4/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 10 Apr 2007 22:11:01 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> > I think this means that if CONFIG_32BIT=y, s390 networking gets the whizzy
> > assembly version and if CONFIG_32BIT=n, it gets to use the generic version.
> >
> > Possibly the whizzy version could be used if CONFIG_32BIT=n, too.  But
> > I'd let the s390 people worry about that ;)
> 
> If CONFIG_32BIT=n we don't need __div64_32 at all, do we? Just use the
> real 64 / 64 bit division.

That's right, Andrew missed the BITS_PER_LONG check in lib/div64.c
:-)
