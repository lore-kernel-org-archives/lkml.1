Return-Path: <linux-kernel-owner+w=401wt.eu-S1764214AbXGPXXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764214AbXGPXXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbXGPXXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:23:14 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:41563 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbXGPXXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:23:13 -0400
Message-ID: <469BFDA7.1040204@gmail.com>
Date: Tue, 17 Jul 2007 01:22:15 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Bodo Eggert <7eggert@gmx.de>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8FO1e-2jW-35@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it>	 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>	 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>	 <469BF104.1040703@gmail.com>	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>	 <469BF768.6040200@gmail.com> <2c0942db0707161613lff9c07bpcf002b9139163a86@mail.gmail.com>
In-Reply-To: <2c0942db0707161613lff9c07bpcf002b9139163a86@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 01:13 AM, Ray Lee wrote:

> Given that there's actual, y'know, reports of people who can easily
> crash a 4k+interrupt stacks kernel, and not an 8k one, I think the
> current evidence speaks for itself.

Where?

> The point remains that the burden of proof of the safety of the 4k only
> option is upon those people who want to remove the 8k option.

Removing any such option was not the objective of this thread, just lifting 
4K stacks from debug and making it the default. People fortunate enough to 
use workloads where some piece of crap code by accident works more often 
with the current shared 8K stacks then it does with the unshared 4K stacks 
can then still nicely not select it (or fix the code if possible).

Rene.



