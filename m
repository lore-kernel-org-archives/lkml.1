Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbZF1Sch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbZF1Sch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZF1Sca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:32:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39113
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbZF1Sc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:32:29 -0400
Date: Sun, 28 Jun 2009 11:32:34 -0700 (PDT)
Message-Id: <20090628.113234.28471959.davem@davemloft.net>
To: arjan@infradead.org
Cc: joe@perches.com, linux-kernel@vger.kernel.org, trivial@kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 00/62] Remove unnecessary semicolons
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090628104332.482ee449@infradead.org>
References: <20090628101159.4c35a4db@infradead.org>
	<1246209365.13673.5.camel@Joe-Laptop.home>
	<20090628104332.482ee449@infradead.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Sun, 28 Jun 2009 10:43:32 -0700

> On Sun, 28 Jun 2009 10:16:05 -0700
> Joe Perches <joe@perches.com> wrote:
> 
>> On Sun, 2009-06-28 at 10:11 -0700, Arjan van de Ven wrote:
>> > can you improve your descriptions please?
>> > to at least include the why for a change, not just the how and
>> > what...
>> 
>> Is any part of "Remove unnecessary semicolons" unclear?
>> 
>> What would you prefer?
>> 
> 
> your sentence addresses the what question, no the why question
> 
> or in business words: whats the value proposition

I think you're going overboard in these requirements.

Extraneous semi-colons dirty up the code, make it confusing and make
hard to find bugs more likely to be present or (even worse) get added
unintentionally in the future.  And every programmer worth his salt
should be aware of this.
