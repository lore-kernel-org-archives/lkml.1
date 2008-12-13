Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbYLMIVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbYLMIVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 03:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYLMIVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 03:21:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:63749 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYLMIVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 03:21:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WWB/715wJPsNA39vE0F8t2GGBN/3qp8RtFk+KaLen7BNGBmOdxK0xbuHJhlXjhI4Td
         RquxSp2WL3kPbNeJELvAjhc3AM7O1tR/E8B3oy6TjgJujgjwnMDMq8iusXFzIiH2He3j
         eEXBexXdo9x3wLqLnuLHMqXB+JNum0zTJ3d/o=
Date: Sat, 13 Dec 2008 11:20:54 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       fweisbec <fweisbec@gmail.com>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
Message-ID: <20081213082054.GA7559@localhost>
References: <20081212184136.GB14192@localhost> <1229113167.32623.12.camel@localhost.localdomain> <20081212204724.GA26194@localhost> <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com> <20081212205729.GA28554@localhost> <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com> <20081212213538.GA731@localhost> <alpine.DEB.1.10.0812121655090.19351@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812121655090.19351@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Steven Rostedt - Fri, Dec 12, 2008 at 04:56:47PM -0500]
...
| > Steve, here is how it could look like:
| > (I liked first proposal more :)
| 
| I see the confusion. In ftrace.h the function graph tracer config is not 
| inside CONFIG_FUNCTION_TRACER, even though it is dependent on it (or 
| was). OK, just do your first proposal then.
| 
| -- Steve
| 

ok, I sent it yesterday as

	http://lkml.org/lkml/2008/12/12/301
	[PATCH] x86: entry_64 - introduce FTRACE_ frame macro v2

Ingo, will you pick it up?

		- Cyrill -
