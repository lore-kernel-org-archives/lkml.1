Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbXKTAxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbXKTAxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXKTAwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:52:51 -0500
Received: from namei.org ([69.55.235.186]:46785 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752159AbXKTAwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:52:50 -0500
Date: Tue, 20 Nov 2007 11:52:38 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: Paul Moore <paul.moore@hp.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       takedakn@nttdata.co.jp
Subject: Re: [TOMOYO #5 18/18] LSM expansion for TOMOYO Linux.
In-Reply-To: <200711200004.lAK044jG080743@www262.sakura.ne.jp>
Message-ID: <Xine.LNX.4.64.0711201151470.30591@us.intercode.com.au>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
 <200711190836.12940.paul.moore@hp.com> <200711192329.JGB18772.tLHOOSMVFFQOFJ@I-love.SAKURA.ne.jp>
 <200711191039.41533.paul.moore@hp.com> <200711200004.lAK044jG080743@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Tetsuo Handa wrote:

> Hello.
> 
> Paul Moore wrote:
> > My apologies, I mistakenly read the following if statement in your patch:
> > 
> >  +       if (skb == skb_peek(&sk->sk_receive_queue)) {
> >  +               __skb_unlink(skb, &sk->sk_receive_queue);
> >  +               atomic_dec(&skb->users);
> >  +       }
> > 
> > I read the conditional as the following:
> > 
> >  +       if (skb = skb_peek(&sk->sk_receive_queue)) {
> > 
> > ... which would have caused the problems I was describing.  I'm sorry for all 
> > of the confusion/frustration, you patient explanations are correct; I was 
> > wrong in this particular case.
> No problem.
> 
> 
> 
> To everyone:
> 
>   Are there any remaining worries with skb_recv_datagram()/socket_post_accept()?
> 
>   If nobody has objection, I'd like to cut these skb_recv_datagram()/socket_post_accept() changes
>   and submit to -mm tree.

You should send anything which touches core networking to netdev, too, and 
get an ack from one of the core developers there.


-- 
James Morris <jmorris@namei.org>

