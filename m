Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYK0NjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYK0NjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYK0NjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:39:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59710 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbYK0NjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:39:03 -0500
Date: Thu, 27 Nov 2008 14:49:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-ID: <20081127134932.GN6703@one.firstfloor.org>
References: <20081126140054.GX6703@one.firstfloor.org> <alpine.LFD.2.00.0811262237140.3325@localhost.localdomain> <20081127100602.GF6703@one.firstfloor.org> <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com> <20081127113115.GH6703@one.firstfloor.org> <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com> <20081127123257.GI6703@one.firstfloor.org> <7c86c4470811270428r76702954se8f6e005481a6a35@mail.gmail.com> <20081127124501.GL6703@one.firstfloor.org> <7c86c4470811270530j4f3c5413j9e6e68cee08631a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811270530j4f3c5413j9e6e68cee08631a9@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What about a thread doing this and another one in the middle of read the buffer?

I assume that uses locks. Locking between threads is easy.

> 
> Or what about a thread trying to reset the buffer while you're processing an PMU
> interrupt on another CPU. I know each buffer is per-CPU, but that does not
> prevent two threads for trying to operate on it at the same time from
> different CPUs.

That happens per CPU.

-Andi

-- 
ak@linux.intel.com
