Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYDJXbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYDJXbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYDJXbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:31:04 -0400
Received: from delay-av.club-internet.fr ([194.158.96.170]:46054 "EHLO
	delay-av.club-internet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbYDJXa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:30:59 -0400
X-Greylist: delayed 1220 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Apr 2008 19:30:58 EDT
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: vincent-perrier <vincent-perrier@club-internet.fr>
To: David Miller <davem@davemloft.net>
Cc: jesper.juhl@gmail.com, tilman@imap.cc, lkml@rtr.ca,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
In-Reply-To: <20080410.154651.101700010.davem@davemloft.net>
References: <20080409.182228.193699767.davem@davemloft.net>
	 <47FE3020.1070502@imap.cc>
	 <9a8748490804101509l5d043ff8w565dc44dfeaf0072@mail.gmail.com>
	 <20080410.154651.101700010.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 01:10:29 +0200
Message-Id: <1207869029.19683.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2-1pclos2007 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am an end user, I do not know precisely what bisecting means, but I
have spent some time on bug 8895, I suppose I have totally bisseced it,
but it seems that it has been lost. 
It is clearly a bug and I am still patching every kernel to avoid the 
fib6 crash, obviously I am the only one to get it.

It is true that kernel developper's time is more important than user's
one, but staying modest and respectfull of the brainless bisesting
users is a must! Our time is just as yours, not extensible.

Anyway, keep on the good kernel work, we all need it.


On Thu, 2008-04-10 at 15:46 -0700, David Miller wrote:
> From: "Jesper Juhl" <jesper.juhl@gmail.com>
> Date: Fri, 11 Apr 2008 00:09:11 +0200
> 
> > You can't expect users to know how to debug a problem or even bisect
> > it.
> 
> [ The person you are replying to was being sarcastic, BTW. ]
> 
> That's not the case we're talking about in this specific instance.  In
> this particular case the user is more than capable of bisecting, he
> just isn't willing to invest the time.
> 
> And I'm supposed to be willing to invest the time to analyze the TCP
> dumps or whatever to diagnose the problem?  And I guess I should do
> this for every single networking bug report or issue?  Who is
> going to clone me and the rest of the core networking developers
> so that this is actually tenable?
> 
> That's ludicrious, I don't have a reproducer, this person does.  And
> if they bisect, we'll know _exactly_ what change introduced the
> problem.  Then I can use my brain to figure out the correct way
> to resolve the problem.
> 
> Bisecting is a mindless activity that saves developers tons of time.
> 
> What people don't get is that this is a situation where the "end node
> principle" applies.  When you have limited resources (here:
> developers) you don't push the bulk of the burdon upon them.  Instead
> you push things out to the resource you have a lot of, the end nodes
> (here: users), so that the situation actually scales.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-net" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> &#0;
> 

