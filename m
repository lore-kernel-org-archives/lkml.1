Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZFKR7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZFKR7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZFKR71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:59:27 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:63210 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbZFKR70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wZf0r1HkcUhaqLkvQwOiHCXCNtqQErfwBtn3DmCkGc5+Pu/jUNi9QIzQm65Cdsj+Fs
         iBm6YxFkTt07kJmdShQe1zg79zbTdx9JRavyRfr1w724yNalAjh0n91rWF7WNY6PRHxO
         HLcY/k+KDifPFO+irPqqB9MjVuD3kHnNv3oTw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu>
	 <20090611161714.GA5008@infradead.org>
	 <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
	 <20090611165226.GV8633@ZenIV.linux.org.uk>
	 <1244739378.6691.540.camel@laptop>
	 <20090611170015.GA3651@infradead.org>
	 <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
Date: Thu, 11 Jun 2009 20:59:26 +0300
X-Google-Sender-Auth: a48a83d0792d96e3
Message-ID: <84144f020906111059g6e25a090y4434cfd698f84fb4@mail.gmail.com>
Subject: Re: [GIT PULL] Performance Counters for Linux
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Christoph Hellwig wrote:
>> So what point is there in keeping it in-tree except making life hell for
>> packagers?

On Thu, Jun 11, 2009 at 8:06 PM, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
> Give it up. Packagers can trivially generate their own sub-packages. They
> do it all the time. They already do it for the user-mode header files,
> extracted from the kernel - something you've worked on yourself.
>
> So your point is clearly bogus, and dishonest.
>
> You haven't actually looked the real problem in the eye, and acknowledged
> the disaster that is oprofile. Let's give a _new_ approach a chance, and
> see if we can avoid the mistakes of yesteryear this time.

Yup, I wonder what all the fuzz is about. We already have userspace
tools in the kernel but people keep putting them under Documentation
(to avoid this discussion, probably).

For those who think an external repository is a good idea, I invite
you to compare the success of kmemtrace (kernel memory profiler) and
perf. The former has its userspace part out-of-tree and has gained
zero new developers. Sure, there are probably fewer people interested
in memory profiling and I or Eduard surely don't have the sex appeal
of Ingo Molnar (yet anyway). But even if you take these factors into
account, I'd argue that big part of the success has been the fact that
it's easily accessible and hackable. And that pretty much means that
the code needs to sit in the kernel tree, following kernel development
process.

And really, what do we gain by moving perf out of tree and making it
follow its own release cycle (and getting out of sync eventually)?

                        Pekka
