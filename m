Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbYDZXiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbYDZXiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYDZXio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:38:44 -0400
Received: from gw.goop.org ([64.81.55.164]:40412 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYDZXin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:38:43 -0400
Message-ID: <4813BCF8.3090907@goop.org>
Date: Sat, 26 Apr 2008 16:38:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu, "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap@sources.redhat.com
Subject: Re: [PATCH 1/1] x86: fix text_poke
References: <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org> <20080425230028.GC31226@Krystal> <481265B7.9040505@goop.org> <48126A80.4000203@redhat.com> <4812CA02.8040705@goop.org> <20080426115634.GH16635@ghostprotocols.net>
In-Reply-To: <20080426115634.GH16635@ghostprotocols.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> You do, when you decide to stop tracing. He is not talking about the old
> function, that one, indeed will always be there, but what about the new
> one? When tracing stops we want to remove it and revert to using the old
> one...
>
> But perhaps you are suggesting that the new one, once loaded, stays
> there forever, that would work, but after several tracing sessions one
> would have to eventually reboot the machine due to many modules left
> loaded.

As I said, it doesn't seem like a very satisfactory way to solve the 
problem.

    J

