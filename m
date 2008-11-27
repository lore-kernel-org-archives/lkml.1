Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYK0NlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYK0NlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYK0Nky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:40:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59736 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYK0Nky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:40:54 -0500
Date: Thu, 27 Nov 2008 14:51:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-ID: <20081127135125.GP6703@one.firstfloor.org>
References: <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com> <20081127113115.GH6703@one.firstfloor.org> <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com> <20081127.034247.72331360.davem@davemloft.net> <alpine.LFD.2.00.0811271246200.3325@localhost.localdomain> <20081127123811.GJ6703@one.firstfloor.org> <7c86c4470811270431n5cf1b863tc4f8c7829283e332@mail.gmail.com> <alpine.LFD.2.00.0811271430470.3325@localhost.localdomain> <7c86c4470811270537y57577314we44d3d81b5f7d4a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811270537y57577314we44d3d81b5f7d4a7@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 02:37:47PM +0100, stephane eranian wrote:
> On Thu, Nov 27, 2008 at 2:32 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Thu, 27 Nov 2008, stephane eranian wrote:
> >> That's true for Intel.
> >> On AMD64, I think you can get at most one sample out of a irq-off
> >> region using IBS.
> >
> > Exactly the same amount which you get with the NMI/self_IPI out of an
> > irq-off region.
> >
> Why would you get only one sample per irq-off region if you use NMI?
> I would think you could get multiple, depending on your sampling period
> and the size of the region.

Because of the self IPI. You would need a NMI safe queue between
NMI and self IPI, but then you could as well have the same
queue between NMI and process readers. 

-Andi

-- 
ak@linux.intel.com
