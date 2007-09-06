Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbXIFTYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbXIFTYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 15:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbXIFTX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 15:23:56 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:59926
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbXIFTXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 15:23:55 -0400
Date: Thu, 06 Sep 2007 12:23:45 -0700 (PDT)
Message-Id: <20070906.122345.74744962.davem@davemloft.net>
To: anders.blomdell@control.lth.se
Cc: linux-kernel@vger.kernel.org
Subject: Re: Stray nulls when reading from AF_UNIX sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <46E02137.8030600@control.lth.se>
References: <46E02137.8030600@control.lth.se>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Blomdell <anders.blomdell@control.lth.se>
Date: Thu, 06 Sep 2007 17:48:07 +0200

>     return copied ? : err;
>   }
> 
> Shouldn't this read:
> 
>     return copied ? copied : err;
> 
> Or am I missing something?

These two statements are equivalent, the first version is
a shorthand allowed by gcc.
