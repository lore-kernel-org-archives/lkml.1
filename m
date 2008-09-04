Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbYIDNDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbYIDNDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYIDNC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:02:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59387 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYIDNC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 09:02:57 -0400
Date: Thu, 4 Sep 2008 15:06:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       hpa@zytor.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080904130609.GD18288@one.firstfloor.org>
References: <20080903195122.73905236@infradead.org> <873akgw251.fsf@basil.nowhere.org> <20080904133419.3704490b@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904133419.3704490b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 01:34:19PM +0100, Alan Cox wrote:
> On Thu, 04 Sep 2008 14:01:46 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Arjan van de Ven <arjan@infradead.org> writes:
> > 
> > > Add basic sanity checks to the syscall execution patch
> > 
> > This just means that the root kits will switch to patch
> > the first instruction of the entry points instead.
> > 
> > So the protection will be zero to minimal, but the overhead will
> > be there forever.
> 
> Agreed entirely. This is a waste of time and a game not worth playing.
> The only place you can expect to make a difference here is in virtualised

Even that can be circumvented by patching indirect pointers (or pointer 
to objects with indirect pointers) in any writable object. Or in
a couple of other ways.

But yes it would still seem like a reasonable useful improvement.

-Andi

-- 
ak@linux.intel.com
