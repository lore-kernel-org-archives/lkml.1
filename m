Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbYBYGQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbYBYGQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbYBYGQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:16:19 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47911 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYBYGQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:16:18 -0500
Date: Mon, 25 Feb 2008 08:16:17 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Michael Buesch <mb@bu3sch.de>
cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alexey Zaytsev <zaytsev.a@protei.ru>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
In-Reply-To: <200802241816.01784.mb@bu3sch.de>
Message-ID: <Pine.LNX.4.64.0802250814450.10065@sbz-30.cs.Helsinki.FI>
References: <47BEAF3B.3080809@protei.ru> <200802241529.50967.mb@bu3sch.de>
 <f19298770802240839w2c19fd52vb0d170359ba56fc5@mail.gmail.com>
 <200802241816.01784.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Sun, 24 Feb 2008, Michael Buesch wrote:
> > The ony way I see this was possible, you manually changed the
> > module loading order, so that the b43xx module was loaded prior
> > to the ssb and b44 modules. Right?
> 
> Right. So "so I'm left with either no wifi or no ethenet" being wrong.

Lets make this simple: it used to work before and now it doesn't. 
Therefore it's a regression that must be addressed. Period.

			Pekka
