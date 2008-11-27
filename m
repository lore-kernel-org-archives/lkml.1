Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYK0NkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYK0NkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYK0Njz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:39:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59721 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYK0Njy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:39:54 -0500
Date: Thu, 27 Nov 2008 14:50:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: eranian@gmail.com, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-ID: <20081127135026.GO6703@one.firstfloor.org>
References: <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com> <20081127113115.GH6703@one.firstfloor.org> <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com> <20081127.034247.72331360.davem@davemloft.net> <alpine.LFD.2.00.0811271246200.3325@localhost.localdomain> <20081127123811.GJ6703@one.firstfloor.org> <7c86c4470811270431n5cf1b863tc4f8c7829283e332@mail.gmail.com> <alpine.LFD.2.00.0811271430470.3325@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811271430470.3325@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 02:32:33PM +0100, Thomas Gleixner wrote:
> On Thu, 27 Nov 2008, stephane eranian wrote:
> > That's true for Intel.
> > On AMD64, I think you can get at most one sample out of a irq-off
> > region using IBS.
> 
> Exactly the same amount which you get with the NMI/self_IPI out of an
> irq-off region.

True. It would really need a NMI safe queue. 

-Andi

-- 
ak@linux.intel.com
