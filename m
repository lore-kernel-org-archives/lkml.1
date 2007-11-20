Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbXKTAEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbXKTAEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXKTAEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:04:15 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61736 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbXKTAEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:04:14 -0500
Message-Id: <200711200004.lAK044jG080743@www262.sakura.ne.jp>
Subject: Re: [TOMOYO #5 18/18] LSM expansion for TOMOYO Linux.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Paul Moore <paul.moore@hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Nov 2007 09:04:04 +0900
References: <20071116173439.796600895@I-love.SAKURA.ne.jp> <200711190836.12940.paul.moore@hp.com> <200711192329.JGB18772.tLHOOSMVFFQOFJ@I-love.SAKURA.ne.jp> <200711191039.41533.paul.moore@hp.com>
In-Reply-To: <200711191039.41533.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul Moore wrote:
> My apologies, I mistakenly read the following if statement in your patch:
> 
>  +       if (skb == skb_peek(&sk->sk_receive_queue)) {
>  +               __skb_unlink(skb, &sk->sk_receive_queue);
>  +               atomic_dec(&skb->users);
>  +       }
> 
> I read the conditional as the following:
> 
>  +       if (skb = skb_peek(&sk->sk_receive_queue)) {
> 
> ... which would have caused the problems I was describing.  I'm sorry for all 
> of the confusion/frustration, you patient explanations are correct; I was 
> wrong in this particular case.
No problem.



To everyone:

  Are there any remaining worries with skb_recv_datagram()/socket_post_accept()?

  If nobody has objection, I'd like to cut these skb_recv_datagram()/socket_post_accept() changes
  and submit to -mm tree.

Regards.
