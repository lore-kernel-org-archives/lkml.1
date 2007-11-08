Return-Path: <linux-kernel-owner+w=401wt.eu-S1763364AbXKHXuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763364AbXKHXuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 18:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761256AbXKHXud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 18:50:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43963
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759947AbXKHXud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 18:50:33 -0500
Date: Thu, 08 Nov 2007 15:26:25 -0800 (PST)
Message-Id: <20071108.152625.165433485.davem@davemloft.net>
To: peterz@infradead.org
Cc: clameter@sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <1194553148.20832.10.camel@lappy>
References: <1194522615.6289.136.camel@twins>
	<Pine.LNX.4.64.0711081030380.7871@schroedinger.engr.sgi.com>
	<1194553148.20832.10.camel@lappy>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 08 Nov 2007 21:19:08 +0100

> 
> On Thu, 2007-11-08 at 10:31 -0800, Christoph Lameter wrote:
> > On Thu, 8 Nov 2007, Peter Zijlstra wrote:
> > 
> > > I don't like those shouting macros.
> > 
> > The convention for macros is to use upper case.
> 
> We have plent macros that look like regular functions. And as a primary
> interface to this functionality these shouting things look really out of
> place.

I disagree, macros in upper case make sense here.  Macros should SHOUT
at you because CPP is MAGIC and has side effects that normal real
functions do not have, and therefore you need to be REMINDED.

And, honestly, aren't there more important issues about his patches to
review than macro capitalization?
