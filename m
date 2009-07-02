Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZGBOj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZGBOj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZGBOjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:39:18 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:38875 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbZGBOjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:39:18 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 2 Jul 2009 07:39:04 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Jiri Olsa <jolsa@redhat.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       jarkao2@gmail.com, oleg@redhat.com
Subject: Re: [PATCHv4 2/2] memory barrier: adding smp_mb__after_lock
In-Reply-To: <4A4C5983.7000501@gmail.com>
Message-ID: <alpine.DEB.1.10.0907020738020.5194@makko.or.mcafeemobile.com>
References: <20090702063259.GA3429@jolsa.lab.eng.brq.redhat.com> <20090702063624.GC3429@jolsa.lab.eng.brq.redhat.com> <4A4C5983.7000501@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-761880546-1246545545=:5194"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-761880546-1246545545=:5194
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 2 Jul 2009, Eric Dumazet wrote:

> Jiri Olsa a écrit :
> > Adding smp_mb__after_lock define to be used as a smp_mb call after
> > a lock.  
> > 
> > Making it nop for x86, since {read|write|spin}_lock() on x86 are 
> > full memory barriers.
> > 
> > wbr,
> > jirka
> > 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> 
> Maybe we should remind that sk_has_helper() is always called
> right after a call to read_lock() as in :
> 
> 	read_lock(&sk->sk_callback_lock);
> 	if (sk_has_sleeper(sk))
> 		wake_up_interruptible_all(sk->sk_sleep);

Agreed, that'd be to have it in the source code comment.


- Davide


--8323329-761880546-1246545545=:5194--
