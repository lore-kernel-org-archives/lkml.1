Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYBWL5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYBWL5u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYBWL5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:57:42 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60844 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYBWL5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:57:42 -0500
Date: Sat, 23 Feb 2008 13:57:39 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Michael Buesch <mb@bu3sch.de>,
       Alexey Zaytsev <zaytsev.a@protei.ru>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linville@tuxdriver.com,
       davem@sunset.davemloft.net
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
In-Reply-To: <f19298770802230351i7a1bdba8pcb1faf4af9b7d385@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802231353440.27587@sbz-30.cs.Helsinki.FI>
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de> 
 <47BF101F.30301@protei.ru> <200802221848.37902.mb@bu3sch.de> 
 <20080223110751.GN23833@elte.hu>  <84144f020802230318hec5fe97h84c797a56b0dd5db@mail.gmail.com>
  <20080223112436.GA31304@elte.hu>  <f19298770802230332s286b8ac4ldbd64b6996cba308@mail.gmail.com>
  <84144f020802230337s35c72b50wf8b892777bff42a2@mail.gmail.com>
 <f19298770802230351i7a1bdba8pcb1faf4af9b7d385@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Sat, Feb 23, 2008 at 2:37 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >  So does reverting commit 753f492093da7a40141bfe083073400f518f4c68
> >  ("[B44]: port to native ssb support") fix the regression?
> >
 
On Sat, 23 Feb 2008, Alexey Zaytsev wrote:
> Compiling it right now.
> 
> I'm sure it fixes the problem, but I don't feel like we should revert
> it. I can't
> be sure it won't cause any other problems, and anyway, this does not look
> right a solution. Any other driver (rightfully) requiring the SSB_HOST would
> then also break the bcm43xx driver.
> 
> I'll send an simplified patch in a few minutes.

The point here is that it's Michael's patch and I don't want to start 
blaming anyone until you've verified it actually broke your setup. And if 
the problem was actually caused by that patch, Michael needs to either ACK 
your patch or fix it himself.

			Pekka
