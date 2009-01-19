Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbZASN0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbZASN0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZASNZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:25:34 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:47397 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760656AbZASNZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PFqATrXW5DYoN4rMONOfmVe6Ch8eg55InK5LjyTcMOiLT5WHFc01FUlOedQNpfUAPr
         3B/UoWMPZF9Vl1uTkDTDVYBDZ5HHtzjFEeLeaFwidDHaY7kNPAsbznxeJdF9SKHc6Wfm
         Ip4Yupj+tP2pBZ3FEFY7oyzlsymbNuV31X+ak=
Message-ID: <c62985530901190525j456f4f1ds6f610fd5241b2aa7@mail.gmail.com>
Date: Mon, 19 Jan 2009 14:25:29 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace based hard lockup detector
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0901190815400.27726@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4973cff5.05a0660a.650c.2f54@mx.google.com>
	 <alpine.DEB.1.10.0901190757330.17050@gandalf.stny.rr.com>
	 <20090119130442.GA6876@elte.hu>
	 <alpine.DEB.1.10.0901190815400.27726@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/19 Steven Rostedt <rostedt@goodmis.org>:
> Ah, OK, the check is in the function tracer. Hmm, my logdev code had an
> option to enable tracing at early bootup. Instead of using the normal
> memory alloction for the ring buffer, it needed to use alloc_bootmem. I
> wonder if it would be worth it to allow for a tracer to do the same if it
> needs to be allocated early on (before memory is initialized)?
>
> --Steve


Hi Steve,

Yeah I think that would be a good idea.


BTW, tote that for the moment, this hard lockup detector is basic, but
I could even make it relying
to the function graph tracer and then dump the whole stack of
functions called. I think that could
give a more precise backtrace.... (and more human readable).
