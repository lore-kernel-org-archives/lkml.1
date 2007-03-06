Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbXCFA0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbXCFA0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXCFA0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:26:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53532
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932809AbXCFA0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:26:21 -0500
Date: Mon, 05 Mar 2007 16:26:20 -0800 (PST)
Message-Id: <20070305.162620.04006691.davem@davemloft.net>
To: dmlb2000@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE Availability Inconsistency
From: David Miller <davem@davemloft.net>
In-Reply-To: <9c21eeae0703051604l20a029c3r8cf09d792ba523be@mail.gmail.com>
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
	<20070305.160303.59493440.davem@davemloft.net>
	<9c21eeae0703051604l20a029c3r8cf09d792ba523be@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David Brown" <dmlb2000@gmail.com>
Date: Mon, 5 Mar 2007 16:04:24 -0800

> On 3/5/07, David Miller <davem@davemloft.net> wrote:
> > From: "David Brown" <dmlb2000@gmail.com>
> > Date: Mon, 5 Mar 2007 15:55:06 -0800
> >
> > > I'm kinda wondering how I'm supposed to write portable user-space code
> > > if I want to use the PAGE_SIZE define on different architectures.
> >
> > Call getpagesize().
> >
> 
> Thanks, but that still leaves PAGE_SIZE available for some
> architectures and not for others shouldn't this be moved inside
> __KERNEL__ in i386 and x86_64 then?

I definitely think so.
