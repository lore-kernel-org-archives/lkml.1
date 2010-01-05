Return-Path: <linux-kernel-owner+w=401wt.eu-S932102Ab0AETBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0AETBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215Ab0AETB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:01:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40831 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab0AETB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:01:27 -0500
Date: Tue, 5 Jan 2010 19:00:47 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Simon Horman <horms@verge.net.au>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Venkappa Mala <Venkappa.Mala@lntinfotech.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: Linux kernel crash dumps for ARM
Message-ID: <20100105190047.GD30868@flint.arm.linux.org.uk>
References: <EB1A7C66AD0C92419BFFC785A947865A09EA8C9129@BLRINMSMBX01.bglrodc.lntinfotech.com> <m17hrx9lgo.fsf@fess.ebiederm.org> <20100105084850.GA27860@linux-sh.org> <20100105091625.GA19871@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105091625.GA19871@verge.net.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 08:16:28PM +1100, Simon Horman wrote:
> To add to this, my understanding is that kexec support varies across
> different ARM platforms - that is to say, it works on some and fails on
> others. While this seems to be slowly improving, I'm also aware of any list
> of what is supported and what isn't.

I'm unaware of that; the only area of weakness with kexec that I'm
aware of is when the ARMv7 processor support didn't implement the
necessary code to bring the caches/mmu/tlbs into a safe state for
software-reboot, which is also what's required by kexec.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
