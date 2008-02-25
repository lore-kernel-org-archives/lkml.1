Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYBYGyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYBYGyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYBYGyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:54:31 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40042 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYBYGya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:54:30 -0500
Date: Mon, 25 Feb 2008 08:54:28 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg KH <greg@kroah.com>
cc: Michael Buesch <mb@bu3sch.de>, Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Alexey Zaytsev <zaytsev.a@protei.ru>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
In-Reply-To: <20080225064935.GA20997@kroah.com>
Message-ID: <Pine.LNX.4.64.0802250852240.10623@sbz-30.cs.Helsinki.FI>
References: <47BEAF3B.3080809@protei.ru> <200802241529.50967.mb@bu3sch.de>
 <f19298770802240839w2c19fd52vb0d170359ba56fc5@mail.gmail.com>
 <200802241816.01784.mb@bu3sch.de> <Pine.LNX.4.64.0802250814450.10065@sbz-30.cs.Helsinki.FI>
 <20080225064935.GA20997@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sun, 24 Feb 2008, Greg KH wrote:
> > Lets make this simple: it used to work before and now it doesn't. 
> > Therefore it's a regression that must be addressed. Period.
> 
> Isn't the resolution Michael is suggesting is, "use the different driver"?

Alexey said it didn't work but even if it did, we don't let old drivers 
_regress_ as long as they're in the tree. There are plenty of precedents 
here so I don't see why this particular Broadcom driver is any different.

			Pekka
