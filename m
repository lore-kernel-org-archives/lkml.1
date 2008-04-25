Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbYDYHt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbYDYHt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbYDYHtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:49:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49003
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754264AbYDYHto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:49:44 -0400
Date: Fri, 25 Apr 2008 00:49:43 -0700 (PDT)
Message-Id: <20080425.004943.148536408.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com, mingo@elte.hu,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
From: David Miller <davem@davemloft.net>
In-Reply-To: <48118B73.6000700@gmail.com>
References: <4811090A.9030809@gmail.com>
	<20080424.183558.96469288.davem@davemloft.net>
	<48118B73.6000700@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Fri, 25 Apr 2008 09:42:43 +0200

> On 04/25/2008 03:35 AM, David Miller wrote:
> > From: Jiri Slaby <jirislaby@gmail.com>
> > Date: Fri, 25 Apr 2008 00:26:18 +0200
> > 
> >> ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadccf0 
> > 
> > 0xf0...  Is this a 4-cpu machine?
> 
> It's a 2 cores machine.

Two hyperthreads per-core?

If so that could match up to the pattern.  It is just one theory
though.  The wireless possibility holds just as much weight.
