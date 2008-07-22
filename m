Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYGVUnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYGVUnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYGVUnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:43:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60993
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbYGVUnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:43:41 -0400
Date: Tue, 22 Jul 2008 13:43:41 -0700 (PDT)
Message-Id: <20080722.134341.143920039.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: kaber@trash.net, mingo@elte.hu, ischram@telenet.be,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
From: David Miller <davem@davemloft.net>
In-Reply-To: <4885D808.9060203@lwfinger.net>
References: <48857F74.2040406@lwfinger.net>
	<20080722.043220.247312412.davem@davemloft.net>
	<4885D808.9060203@lwfinger.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Tue, 22 Jul 2008 07:52:24 -0500

> David Miller wrote:
> > From: Larry Finger <Larry.Finger@lwfinger.net>
> > Date: Tue, 22 Jul 2008 01:34:28 -0500
> > 
> >> David Miller wrote:
> >>> From: Larry Finger <Larry.Finger@lwfinger.net>
> >>> Date: Mon, 21 Jul 2008 17:40:10 -0500
> >>>
> >>>> Sorry :(
> >>>>
> >>>> I used the davem patch, the second version of your first one, and your second 
> >>>> one. Both problems persist.
> >>>>
> >>>> Still plugging away on bisection.
> >>> GIT bisecting the lockdep problem is surely going the land you on:
> >>>
> >>> commit e308a5d806c852f56590ffdd3834d0df0cbed8d7
> >> No. It landed on this one.
> > 
> > For the lockdep warnings?
> 
> No - this one triggers the kernel BUG as follows:

Well, we were trying to fix the lockdep warnings.  One
thing at a time :-)

And that BUG is now just a WARN in Linus's tree, so if
you update you should get further along.
