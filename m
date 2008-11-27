Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYK0MgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYK0MgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYK0MgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:36:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55038 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbYK0MgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:36:09 -0500
Date: Thu, 27 Nov 2008 13:46:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-ID: <20081127124640.GM6703@one.firstfloor.org>
References: <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com> <20081127113115.GH6703@one.firstfloor.org> <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com> <20081127.034247.72331360.davem@davemloft.net> <alpine.LFD.2.00.0811271246200.3325@localhost.localdomain> <20081127123811.GJ6703@one.firstfloor.org> <7c86c4470811270431n5cf1b863tc4f8c7829283e332@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811270431n5cf1b863tc4f8c7829283e332@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's true for Intel.
> On AMD64, I think you can get at most one sample out of a irq-off
> region using IBS.

Assuming that the irqs off regions are not too long (and that's
usually the case) that should be enough, shouldn't it?

Sure there are still CPUs with neither IBS or PEBS.

-Andi

-- 
ak@linux.intel.com
