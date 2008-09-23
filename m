Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYIWFgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYIWFgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 01:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYIWFgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 01:36:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:50322 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYIWFgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 01:36:24 -0400
Subject: Re: PTE access rules & abstraction
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: npiggin@suse.de, jeremy@goop.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, hugh@veritas.com
In-Reply-To: <20080922.201610.246167553.davem@davemloft.net>
References: <48D739B2.1050202@goop.org> <1222117551.12085.39.camel@pasglop>
	 <20080923031037.GA11907@wotan.suse.de>
	 <20080922.201610.246167553.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 15:35:06 +1000
Message-Id: <1222148106.12085.95.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 20:16 -0700, David Miller wrote:
> 
> To a certain extent this is what BSD does in it's pmap layer, except
> that they don't have the page table datastructure abstraction like
> Linus does in the generic code, and which I think was a smart design
> decision on our side.
> 
> All of the pmap modules in BSD are pretty big and duplicate a lot of
> code that arch's don't have to be mindful about under Linux.

I definitely agree, I don't think we want to go away from the page table
as being the abstraction :-) But I'm wondering if we can do a little bit
better with the accessors to those page tables.

BTW. am I the only one to have got one copy of David's reply (that I'm
quoting) coming with a From: Nick Piggin in the headers ? (apparently
coming from kvack).

Cheers,
Ben.


