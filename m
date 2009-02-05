Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZBEXdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZBEXdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbZBEXdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:33:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752998AbZBEXdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:33:03 -0500
Date: Thu, 5 Feb 2009 15:32:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: jeff.chua.linux@gmail.com, herbert@gondor.apana.org.au, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8 breaks rlogin
In-Reply-To: <20090205.152906.221253085.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0902051530520.3048@localhost.localdomain>
References: <b6a2187b0902050641h7943816ds26275a320e724440@mail.gmail.com> <20090205.152906.221253085.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Feb 2009, David Miller wrote:
> 
> Herbert, please help Jeff try to track down the cause of this.
> If we can't figure it out soon I'll have to revert.

Why is there even any discussion?

URG is broken as a concept, no sane/modern use case exists. It's totally 
uninteresting _except_ as a "legacy binary" issue, so

 - there's no point in trying to "improve" it.

 - even just a whiff of "breaks legacy app" just says "revert it".

No?

		Linus
