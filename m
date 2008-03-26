Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYCZFO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYCZFO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 01:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYCZFOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 01:14:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44450 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYCZFOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 01:14:47 -0400
Date: Wed, 26 Mar 2008 06:17:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jack Steiner <steiner@sgi.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 5/8] x86_64: Add UV specific header for MMR definitions
Message-ID: <20080326051759.GD2170@one.firstfloor.org>
References: <20080324182116.GA28285@sgi.com> <20080325082756.GA6589@infradead.org> <87myoni0gp.fsf@basil.nowhere.org> <20080326000820.GA18701@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326000820.GA18701@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 08:08:20PM -0400, Christoph Hellwig wrote:
> On Tue, Mar 25, 2008 at 11:04:22AM +0100, Andi Kleen wrote:
> > bitfields are only problematic on portable code, which this isn't.
> 
> it's still crappy to read and a bad example for others.  

I personally think bitfield code is actually easier to read
than manual shift/mask etc.

Avoiding bitfields is just a rule of thumb for portability, but that one
does not apply here.

I would say Joern's recent comment on religion vs common sense
for CodingStyle applies very well here.

> And last time
> I heard about UV it also included an ia64 version, but that's been
> loooong ago.

bitfield rules should be 100% the same between x86 and ia64

-Andi
