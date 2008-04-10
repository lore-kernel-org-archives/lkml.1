Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbYDJXDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbYDJXDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbYDJXCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:02:50 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:7129 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbYDJXCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zbc1T09TN9H2az62HLFWpgBHFewgWgW09hLu0Rg0Hugpeaz/UFXqLf5Hu5cVl2oMEBNLe2xkl+yFz1iuVEtVnnnUgDl8yt7ECGCMKcG/FW4AtgyAVS/FhbEyguBaAcs1ZZc3mOcpYjJI/wbUNgiHtpbKGA8T9EEtst3yNTML+t8=
Message-ID: <9a8748490804101602g5006db1eq8a192bf067112aeb@mail.gmail.com>
Date: Fri, 11 Apr 2008 01:02:35 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: 2.6.25-rc8: FTP transfer errors
Cc: tilman@imap.cc, lkml@rtr.ca, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
In-Reply-To: <20080410.154651.101700010.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080409.182228.193699767.davem@davemloft.net>
	 <47FE3020.1070502@imap.cc>
	 <9a8748490804101509l5d043ff8w565dc44dfeaf0072@mail.gmail.com>
	 <20080410.154651.101700010.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2008, David Miller <davem@davemloft.net> wrote:
> From: "Jesper Juhl" <jesper.juhl@gmail.com>
>  Date: Fri, 11 Apr 2008 00:09:11 +0200
>
>
>  > You can't expect users to know how to debug a problem or even bisect
>  > it.
>
>
> [ The person you are replying to was being sarcastic, BTW. ]
>

So this was indeed a case of "I didn't get it", that's good ;-)


>  That's not the case we're talking about in this specific instance.  In
>  this particular case the user is more than capable of bisecting, he
>  just isn't willing to invest the time.
>
>  And I'm supposed to be willing to invest the time to analyze the TCP
>  dumps or whatever to diagnose the problem?  And I guess I should do
>  this for every single networking bug report or issue?  Who is
>  going to clone me and the rest of the core networking developers
>  so that this is actually tenable?
>

I know that lack of developers is a problem and that the more users
(especially capable ones) help the better. Aparently I misunderstood
the post and read it as really saying "if users don't want to do the
work then we don't want the bug reports" and that's what made me
react.

>  That's ludicrious, I don't have a reproducer, this person does.  And
>  if they bisect, we'll know _exactly_ what change introduced the
>  problem.  Then I can use my brain to figure out the correct way
>  to resolve the problem.
>
Sure, when things can be done that way that is the best approach, sure.

>  Bisecting is a mindless activity that saves developers tons of time.
>
I know.

>  What people don't get is that this is a situation where the "end node
>  principle" applies.  When you have limited resources (here:
>  developers) you don't push the bulk of the burdon upon them.  Instead
>  you push things out to the resource you have a lot of, the end nodes
>  (here: users), so that the situation actually scales.
>
Again I can''t do anything but agree with you. You are right. When
it's possible to do the work this way everyone wins.
I was just trying to say that when it can't be done that way or the
user won't, then the bug report still has value and still deserves to
be taken seriously (although it probably goes lower in the pile than
the bugs where the end users actually do bisect or whatever).


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
