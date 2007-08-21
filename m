Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbXHULyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbXHULyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbXHULyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:54:39 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3325 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbXHULyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:54:38 -0400
Date: Tue, 21 Aug 2007 13:54:51 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Mike Galbraith <efault@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       Michael Chang <thenewme91@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <1187681583.6183.25.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.64.0708211252280.1817@scrub.home>
References: <Pine.LNX.4.64.0708011955430.1817@scrub.home>  <20070801190556.GA1199@elte.hu>
  <Pine.LNX.4.64.0708100037460.1817@scrub.home>  <20070810054948.GA5908@elte.hu>
  <Pine.LNX.4.64.0708101459530.1817@scrub.home> 
 <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com> 
 <Pine.LNX.4.64.0708101919270.1817@scrub.home>  <20070810194705.GH6002@1wt.eu>
  <Pine.LNX.4.64.0708102235320.1817@scrub.home>  <20070810213630.GA13910@elte.hu>
 <20070811003052.GA18812@elte.hu>  <Pine.LNX.4.64.0708191936110.1817@scrub.home>
 <1187681583.6183.25.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 21 Aug 2007, Mike Galbraith wrote:

> I thought this was history.  With your config, I was finally able to
> reproduce the anomaly (only with your proggy though), and Ingo's patch
> does indeed fix it here.
> 
> Freshly reproduced anomaly and patch verification, running 2.6.23-rc3
> with your config, both with and without Ingo's patch reverted:

I did update to 2.6.23-rc3-git1 first, but I ended up reverting the patch, 
as I didn't notice it had been applied already. Sorry about that.
With this patch the underflows are gone, but there are still the 
overflows, so the questions from the last mail still remain.

bye, Roman
