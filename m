Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYDFB1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYDFB1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 21:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbYDFB1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 21:27:45 -0400
Received: from [194.117.236.238] ([194.117.236.238]:33161 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbYDFB1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 21:27:44 -0400
Date: Sun, 6 Apr 2008 04:27:20 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tom Zanussi <zanussi@us.ibm.com>
Subject: Re: [PATCH] relay: add buffer-only functionality, allowing for
 early kernel tracing
Message-ID: <20080406042720.7a9bcbef@linux360.ro>
In-Reply-To: <20080404164022.GA1762@Krystal>
References: <20080404183303.2e239a20@linux360.ro>
	<20080404160623.GC32126@Krystal>
	<20080404191943.2d708cbf@linux360.ro>
	<20080404164022.GA1762@Krystal>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008 12:40:22 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> As far as I am concerned, I can only merge this in the LTTng project
> to try it. I've added Tom Zanussi, the author of relay, who might
> have some ideas to share with us. I would wait until we have a more
> precise idea of the API before I modify LTTng to start using it.
> 
> Regards,
> 
> Mathieu

Hi,

I've tested my patch a bit more and ran into a problem, and fixed it.
Forget the old patch, it will panic the kernel if it has to cross
sub-buffer boundaries. I'll polish the new one a bit (maybe update the
docs) and resubmit, along with a piece of code from my GSoC project that
uses the early relay interface (may provide an easy to try demo).

Unfortunately, as for doing earlier than kmem_cache_init() tracing, I
don't have the time right now, as I have to carry on with my GSoC
project. I looked through the source more thoroughly and the needed
changes are not trivial at all. I'm not saying I won't work on it, but
it won't be a priority.

By the way, I got a "delivery failure" message... is something wrong
with Tom Zanussi's e-mail address? Google showed 2007 LKML entries with
his e-mail address as <zanussi at comcast dot net>. In any case, when
I'll resubmit the patch, I'll add this other address in the Cc list. Or
should we reach him another way?

I'd like to get this merged as it is so far, and mailing it directly to
akpm (or worse, Linus) doesn't sound like a good idea.


Cheers,
Eduard
