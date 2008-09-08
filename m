Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYIHVf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYIHVf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 17:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYIHVfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 17:35:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36105
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754123AbYIHVfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 17:35:13 -0400
Date: Mon, 08 Sep 2008 14:35:04 -0700 (PDT)
Message-Id: <20080908.143504.121592746.davem@davemloft.net>
To: david-b@pacbell.net
Cc: James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
From: David Miller <davem@davemloft.net>
In-Reply-To: <200809081429.57805.david-b@pacbell.net>
References: <200809081213.37705.david-b@pacbell.net>
	<1220905689.8074.68.camel@localhost.localdomain>
	<200809081429.57805.david-b@pacbell.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Mon, 8 Sep 2008 14:29:57 -0700

> On Monday 08 September 2008, James Bottomley wrote:
> > All the PDC real time clock calls can do are read and set, nothing else,
> > so it's idealy suited to the GEN_RTC infrastructure ... what's the
> > benefit in moving it to RTC_CLASS?
> 
> The same benefit always found in sharing infrastructure.  Lots
> of little differences/bugs go away.  Infrastructure improvements
> and bugfixes get leveraged.  Dead and crufticious code can vanish.
> And so forth.

I absolutely and positively agree with David here.

I just last week converted all of both sparc ports to the generic
RTC layer and what a huge burdon has been moved off of my shoulders.

The RTC layer is very nice and it even allows writing drivers for
very simplistic RTC devices (even ones that cannot be written)
with ease.  I had two such cases to handle on sparc64.


