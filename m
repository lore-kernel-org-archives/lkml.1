Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZBEXiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZBEXiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZBEXiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:38:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42196
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752998AbZBEXiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:38:05 -0500
Date: Thu, 05 Feb 2009 15:38:01 -0800 (PST)
Message-Id: <20090205.153801.131216873.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: jeff.chua.linux@gmail.com, herbert@gondor.apana.org.au, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8 breaks rlogin
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0902051530520.3048@localhost.localdomain>
References: <b6a2187b0902050641h7943816ds26275a320e724440@mail.gmail.com>
	<20090205.152906.221253085.davem@davemloft.net>
	<alpine.LFD.2.00.0902051530520.3048@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Feb 2009 15:32:20 -0800 (PST)

> On Thu, 5 Feb 2009, David Miller wrote:
> > 
> > Herbert, please help Jeff try to track down the cause of this.
> > If we can't figure it out soon I'll have to revert.
> 
> Why is there even any discussion?
> 
> URG is broken as a concept, no sane/modern use case exists. It's totally 
> uninteresting _except_ as a "legacy binary" issue, so
> 
>  - there's no point in trying to "improve" it.
> 
>  - even just a whiff of "breaks legacy app" just says "revert it".
> 
> No?

Sure, and we can put the change back in if we ever figure out what the
problem was.

This change is in 2.6.28 too, so I'll revert and queue the revert up
for -stable as well.
