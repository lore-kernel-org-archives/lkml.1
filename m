Return-Path: <linux-kernel-owner+w=401wt.eu-S1765399AbXGPXqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765399AbXGPXqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbXGPXpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:45:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61898 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXGPXpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:45:54 -0400
Date: Tue, 17 Jul 2007 01:45:48 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Rene Herman <rene.herman@gmail.com>
cc: Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: <469BF768.6040200@gmail.com>
Message-ID: <Pine.LNX.4.58.0707170143200.29868@be1.lrz>
References: <8FO1e-2jW-35@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>
  <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it> 
 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> 
 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> 
 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>  <469BF104.1040703@gmail.com>
 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
 <469BF768.6040200@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1893W4qG7ZzVwA7YtfTu9w9BHEVx7CP075EYuw
 7LYbTgxcdVE9O5TPKxcASxdeFURytaBImMTaTH7IQLfhjBXNxW
 ez97D2C48mzO4OXxi3apg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Rene Herman wrote:
> On 07/17/2007 12:37 AM, Ray Lee wrote:
> > On 7/16/07, Rene Herman <rene.herman@gmail.com> wrote:

> > If at some point one of the pro-4k stacks crowd can prove that all
> > code paths are safe
> 
> I'll do that the minute you prove the current shared 8K stacks are safe. Do 
> we have a deal?

You claim 4k+4k is safe, therefore 8k must be safe, too. But if 8k is 
safe, this does not yet prove that you can store 5k+3k in 4k+4k.
-- 
Funny quotes:
38. Last night I played a blank tape at full blast. The mime next door went
    nuts.
