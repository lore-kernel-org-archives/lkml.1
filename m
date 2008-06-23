Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbYFWCaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbYFWCaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYFWC3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:29:54 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:32489 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753364AbYFWC3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:29:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xnafVF73vHkahSHH3b52fPc8jMGEJFxwHmDZRatJSg1UqdBJx/65FX9GjbsWY0Dok4b1NYQNizzNQPUlOnaHD5Bh31bbJ1KJPaZsi8RRAuOUafMsMjhl836zEsFLNFYqQG5MtCI2aZLsXN17XhxRc+KosWyK2JXHFIbNX4kFpys=  ;
X-YMail-OSG: TPVv8t4VM1n0QsaRkSlNVV5b6vdg3XpVhowGuEQeF4bhS4TEnArm63o1yG_lv8l_UqJ849JpuwuuumNQnDG9.xhdGle_Fn7pPMrMZ8YkCWTx08X2dFaDy7dltCeR7tSOWlQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Ryan Hope" <rmh3093@gmail.com>
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
Date: Mon, 23 Jun 2008 12:29:42 +1000
User-Agent: KMail/1.9.5
Cc: "Peter Zijlstra" <peterz@infradead.org>, linux-mm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com> <1214147244.3223.307.camel@lappy.programming.kicks-ass.net> <48f7fe350806220818n52cc36e9v28bdc6cf2c4cf841@mail.gmail.com>
In-Reply-To: <48f7fe350806220818n52cc36e9v28bdc6cf2c4cf841@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231229.42943.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008 01:18, Ryan Hope wrote:
> Well in the current version of the patchset we are using, one user
> would start playing some game (disabling "Disable Heap Randomization"
> fixed the hardlocks for him... the other user got hardlocks when
> copying an ISO from a reiser4 partition to a reiserfs partition
> (disabling swap fixed the issue for him).

Hmm, nobody has reported such a hang with -mm yet, so maybe it
is another interaction in the patchset. OTOH, probably nobody
much uses -mm and reiser4, and reiser4 does lots of weird fiddling
with pagecache so it could be broken in -mm even.

