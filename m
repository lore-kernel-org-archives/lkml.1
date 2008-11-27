Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYK0LU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYK0LU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 06:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYK0LUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 06:20:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51460 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYK0LUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 06:20:49 -0500
Date: Thu, 27 Nov 2008 12:31:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-ID: <20081127113115.GH6703@one.firstfloor.org>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com> <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain> <20081126140054.GX6703@one.firstfloor.org> <alpine.LFD.2.00.0811262237140.3325@localhost.localdomain> <20081127100602.GF6703@one.firstfloor.org> <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only reason why I have to deal with NMI is not so much to allow
> for profiling irq-off regions but because I have to share the PMU with
> the NMI watchdog. Otherwise I'd have to fail  or disable the NMI watchdog
> on the fly.

The NMI watchdog is now off by default so failing with it enabled
is fine.

Longer term having NMI profiling is still a useful feature I think,
but of course it needs to be implemented cleanly.

-Andi

-- 
ak@linux.intel.com
