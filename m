Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbYDJWrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbYDJWrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbYDJWqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:46:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43092
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752896AbYDJWqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:46:50 -0400
Date: Thu, 10 Apr 2008 15:46:51 -0700 (PDT)
Message-Id: <20080410.154651.101700010.davem@davemloft.net>
To: jesper.juhl@gmail.com
Cc: tilman@imap.cc, lkml@rtr.ca, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <9a8748490804101509l5d043ff8w565dc44dfeaf0072@mail.gmail.com>
References: <20080409.182228.193699767.davem@davemloft.net>
	<47FE3020.1070502@imap.cc>
	<9a8748490804101509l5d043ff8w565dc44dfeaf0072@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jesper Juhl" <jesper.juhl@gmail.com>
Date: Fri, 11 Apr 2008 00:09:11 +0200

> You can't expect users to know how to debug a problem or even bisect
> it.

[ The person you are replying to was being sarcastic, BTW. ]

That's not the case we're talking about in this specific instance.  In
this particular case the user is more than capable of bisecting, he
just isn't willing to invest the time.

And I'm supposed to be willing to invest the time to analyze the TCP
dumps or whatever to diagnose the problem?  And I guess I should do
this for every single networking bug report or issue?  Who is
going to clone me and the rest of the core networking developers
so that this is actually tenable?

That's ludicrious, I don't have a reproducer, this person does.  And
if they bisect, we'll know _exactly_ what change introduced the
problem.  Then I can use my brain to figure out the correct way
to resolve the problem.

Bisecting is a mindless activity that saves developers tons of time.

What people don't get is that this is a situation where the "end node
principle" applies.  When you have limited resources (here:
developers) you don't push the bulk of the burdon upon them.  Instead
you push things out to the resource you have a lot of, the end nodes
(here: users), so that the situation actually scales.
