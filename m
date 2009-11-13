Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZKMQZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZKMQZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 11:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbZKMQZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 11:25:25 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:33498 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbZKMQZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 11:25:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=J2PPMnS3QkM8abG8ncxTxNdifGskq2oHQw1mEnKZjq+WSRq7qAyWbamXThHg5N8isX
         IWlWommUYXq/i0WsYyjnkjigGrUS8Waun+0WTMqkrbPoBrIQ5H3rIYhjUgCeAnkbzPsH
         U1iG01rja7oWNCw3WpkzhsKHjk6US63Ti/3p0=
MIME-Version: 1.0
In-Reply-To: <4AFC5C58.9030207@gmail.com>
References: <81bfc67a0911111448q2e7938fcq18adf2454d6bc8f1@mail.gmail.com>
	 <20091112113836.GA7963@ff.dom.local>
	 <81bfc67a0911120546g26627ac5q5860d85f446b29bb@mail.gmail.com>
	 <4AFC5C58.9030207@gmail.com>
Date: Fri, 13 Nov 2009 11:25:25 -0500
Message-ID: <81bfc67a0911130825o6d9b93b2he70677157ad889f2@mail.gmail.com>
Subject: Re: large packet loss take2 2.6.31.x
From: Caleb Cushing <xenoterracide@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I assume it's your only network device on this box and according
> to these reports it's 192.168.1.3 with 192.168.1.1 as the gateway,
> and your only change is kernel on this 192.168.1.3 box, right?

yes, and semi obviously that router is my box (LinkSys wrt 54gl
openwrt kamikaze 8.09.1.

> Since the loss is seen on the first hop already, it seems it should be
> enough to query 192.168.1.1 only - did you try this? If so, does this
> happen from the beginning of the test or after many loops? Could you
> try to repeat this wireshark dump with more data than before (but just
> to be sure there are a few unanswered pings). If possible it would be
> nice to have wireshark or tcpdump data from 192.168.1.1 too, while
> pinged from 192.168.1.3. Please, send it gzipped to bugzilla only plus
> ifconfig eth0 before and after the test (and let us know here).

same bug? or new bug? I can see what I can do to get a tcpdump from
the router.  yes I tried that, I can tell within the first 10 pings. I
should say I don't notice it on every kernel boot, it's ~80% of
reboots (but that's pulled from my behind). but I haven't noticed it
on gfa31221 at all. it's reproducible in 31.6 too (arch just added
that).

> Btw, mtr has text reporting too (--report). Larger things send to
> bugzilla only.

didn't know that, although I should have guessed (or rtfm), thanks.


-- 
Caleb Cushing

http://xenoterracide.blogspot.com
