Return-Path: <linux-kernel-owner+w=401wt.eu-S1763155AbXGQA3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763155AbXGQA3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbXGQA3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:29:36 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:38406 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbXGQA3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:29:35 -0400
Message-ID: <469C0D32.2090102@gmail.com>
Date: Tue, 17 Jul 2007 02:28:34 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: Ray Lee <ray-lk@madrabbit.org>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8FO1e-2jW-35@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>  <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it>  <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>  <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>  <Pine.LNX.4.58.0707161523500.25779@be1.lrz>  <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <Pine.LNX.4.58.0707170143200.29868@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707170143200.29868@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 01:45 AM, Bodo Eggert wrote:

> On Tue, 17 Jul 2007, Rene Herman wrote:
>> On 07/17/2007 12:37 AM, Ray Lee wrote:

>>> If at some point one of the pro-4k stacks crowd can prove that all 
>>> code paths are safe
>> I'll do that the minute you prove the current shared 8K stacks are
>> safe. Do we have a deal?
> 
> You claim 4k+4k is safe, therefore 8k must be safe, too.

No, I most certainly do not. I claim proving that 4K and seperate (per cpu) 
interrupt stacks are safe are exactly the same as proving unshared 8K stacks 
are safe. That is, you don't, no such proof exists other than in the eating 
of the pudding. Ray (and you) in considering !CONFIG_4KSTACKS to be "safer" 
than CONFIG_4KSTACKS suggest that _inevitably_ CONFIG_4KSTACKS would leave 
you with less available stack and I pointed out this isn't be the case.

And in fact, I shouldn't have said "exactly" the same. Unshared interrupt 
stacks make for more determistisc behaviour, so you'd have a harder time 
proven anything to some set limit of uncertainty with the shared 8K stacks 
than with the unshared 4K stacks.

> But if 8k is safe, this does not yet prove that you can store 5k+3k in
> 4k+4k.

I really have not made any claim of the kind. The argument is that with 
CONFIG_4KSTACKS, availeble stack space isn't inevitably less at any point in 
time.

Rene.
