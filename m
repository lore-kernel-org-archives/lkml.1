Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYDYBgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYDYBgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 21:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbYDYBgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 21:36:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42453
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753774AbYDYBgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 21:36:02 -0400
Date: Thu, 24 Apr 2008 18:35:58 -0700 (PDT)
Message-Id: <20080424.183558.96469288.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com, mingo@elte.hu,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
From: David Miller <davem@davemloft.net>
In-Reply-To: <4811090A.9030809@gmail.com>
References: <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>
	<alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
	<4811090A.9030809@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Fri, 25 Apr 2008 00:26:18 +0200

> ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadccf0 

0xf0...  Is this a 4-cpu machine?

I doubt it, because this is on a laptop as far as I can tell,
but I thought I'd ask. :-)

So the clue is setting some byte at ((offset % 8) == 0) into a
structure with 0xf0...


