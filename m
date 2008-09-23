Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYIWGS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYIWGS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 02:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYIWGSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 02:18:48 -0400
Received: from mail.suse.de ([195.135.220.2]:51376 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYIWGSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 02:18:47 -0400
Date: Tue, 23 Sep 2008 08:18:43 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, jeremy@goop.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, hugh@veritas.com
Subject: Re: PTE access rules & abstraction
Message-ID: <20080923061843.GA29718@wotan.suse.de>
References: <48D739B2.1050202@goop.org> <1222117551.12085.39.camel@pasglop> <20080923031037.GA11907@wotan.suse.de> <20080922.201610.246167553.davem@davemloft.net> <1222148106.12085.95.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222148106.12085.95.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 03:35:06PM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2008-09-22 at 20:16 -0700, David Miller wrote:
> > 
> > To a certain extent this is what BSD does in it's pmap layer, except
> > that they don't have the page table datastructure abstraction like
> > Linus does in the generic code, and which I think was a smart design
> > decision on our side.
> > 
> > All of the pmap modules in BSD are pretty big and duplicate a lot of
> > code that arch's don't have to be mindful about under Linux.
> 
> I definitely agree, I don't think we want to go away from the page table
> as being the abstraction :-) But I'm wondering if we can do a little bit
> better with the accessors to those page tables.
> 
> BTW. am I the only one to have got one copy of David's reply (that I'm
> quoting) coming with a From: Nick Piggin in the headers ? (apparently
> coming from kvack).

No. I see that, and so does marc.

http://marc.info/?t=122184627700007&r=1&w=2

And I've only ever seen it from Dave on kvack.
