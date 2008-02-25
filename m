Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYBYMZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYBYMZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 07:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYBYMZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 07:25:40 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52634 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbYBYMZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 07:25:39 -0500
Date: Mon, 25 Feb 2008 14:25:38 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Michael Buesch <mb@bu3sch.de>
cc: Greg KH <greg@kroah.com>, Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Alexey Zaytsev <zaytsev.a@protei.ru>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
In-Reply-To: <200802251319.03819.mb@bu3sch.de>
Message-ID: <Pine.LNX.4.64.0802251423190.21696@sbz-30.cs.Helsinki.FI>
References: <47BEAF3B.3080809@protei.ru> <200802251054.57070.mb@bu3sch.de>
 <84144f020802250411i7a4a7c51h60ed9f9878c86422@mail.gmail.com>
 <200802251319.03819.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Michael Buesch wrote:
> > Neither of which seem like acceptable solutions for a 2.6.23 -> 2.6.24
> > _regression_. Or maybe I am just too naive to believe Linus' statement
> > on not letting the kernel regress...
> 
> So, please sign-off the patch that we have, if you think it's right
> and doesn't cause more regressions.

I did look at the patch and can gladly add a:

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

But this seems backwards. It was _your_ commit that broke the setup and 
the patch touches a driver _you're_ maintaining.

So can we just revert commit 753f492093da7a40141bfe083073400f518f4c68 
("[B44]: port to native ssb support") from 2.6.24 and you can add it back 
to 2.6.25 if the problem indeed does go away?

			Pekka
