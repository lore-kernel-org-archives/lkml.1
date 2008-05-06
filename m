Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbYEFKrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYEFKrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 06:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYEFKq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 06:46:57 -0400
Received: from bay0-omc3-s15.bay0.hotmail.com ([65.54.246.215]:52842 "EHLO
	bay0-omc3-s15.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbYEFKq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 06:46:56 -0400
Message-ID: <BAY103-DAV122A113843FE9574256A0AB2D60@phx.gbl>
X-Originating-IP: [85.32.103.134]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <E1Jrtxr-0004in-00@gondolin.me.apana.org.au> <BAY103-DAV594320AC93E33D7335927B2DA0@phx.gbl>
Subject: Re: 2.6.25 crash: EIP: [<c02e2f14>] xfrm_output_resume+0x64/0x100 ss:esp 0068:c03a1e5c
Date: Tue, 6 May 2008 12:44:33 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 06 May 2008 10:46:55.0268 (UTC) FILETIME=[80371E40:01C8AF66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Berizziwrote:


> Herbert Xu wrote:
>
> > Marco Berizzi <pupilla@hotmail.com> wrote:
> >> Just few minutes ago, another 2.6.25 crash
> >> with this message:
> >>
> >> EIP: [<c028000a>] netif_rx+0x6a/0xd0 SS:ESP 0068:c039f868
> >>
> >> http://80.204.235.230/4.jpg
> >
> > OK, the xfrm_output_resume trail revealed nothing.  Combined
> > with this crash however, it would appear that you've got a problem
> > with live skbs being freed.  Unfortunately such problems are
> > difficult to track down.
> >
> > Perhaps you could enable SLAB debugging to see if we can get
> > closer to the culprit?
>
> Yes indeed, I will try next monday.
>
> > Alternatively you could try a git bisection.
>
> Yes, but it could take forever... :-((
> As I said, I have removed the sfq and htb modules,
> and I would like to wait one week to see if these
> boxes will crash. I have 8 linux boxes running 2.6.25
> with the same .config and only the two with htb/sfq
> qdisc are crashing. Just few minutes ago I have seen
> this message forwarded to netdev by David Miller:
>
> Re: PROBLEM: kernel lockup while changing TC rules
>
> it is talking about htb/sfq. Maybe it is related.
>
> > Unless we have a way of reproducing this there isn't a lot more
> > that we can do I'm afraid.
>
> thanks anyway Herbert.

ok, I can confirm after one week uptime: this problem
is not happening after removing sch_htb/sch_sfq and
cls_fw modules.
What should I do to help track down this problem?


