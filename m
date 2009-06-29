Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbZF2UFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbZF2UFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbZF2UFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:05:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34631 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbZF2UFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:05:38 -0400
Date: Mon, 29 Jun 2009 22:05:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, htejun@gmail.com, oleg@redhat.com,
       davidel@xmailserver.org, eric.dumazet@gmail.com
Subject: Re: [PATCH 1/2] net: adding memory barrier to the poll and receive
	callbacks
Message-ID: <20090629200532.GA3417@jolsa.redhat.com>
References: <20090629140434.GE3845@jolsa.lab.eng.brq.redhat.com> <20090629141445.GF3845@jolsa.lab.eng.brq.redhat.com> <20090629171926.GB2742@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629171926.GB2742@ami.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 07:19:26PM +0200, Jarek Poplawski wrote:
> On Mon, Jun 29, 2009 at 04:14:45PM +0200, Jiri Olsa wrote:
> ...
> > +static inline void sock_poll_wait(struct file *filp, struct sock *sk,
> ...
> > +	sock_poll_wait(file, sk->sk_sleep, wait);
> 
> -----------------------------^^^^^^^^^^^^
> Is it something with my eyes or it wasn't compiled? ;-)
> 
> Jarek P.

your eyes are great, my brain is screwed... sry about that, I'll resend

it was compiled actually.. must have ended up with warning I did not
noticed... thanks!

jirka
