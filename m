Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbYAQXJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbYAQXJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbYAQXJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:09:03 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:45344 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbYAQXJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:09:01 -0500
Date: Thu, 17 Jan 2008 18:08:02 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [-mm Patch] uml: fix a building error
Message-ID: <20080117230802.GA9360@c2.user-mode-linux.org>
References: <20080117105606.ff89e9e9.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE5E90DF@orsmsx423.amr.corp.intel.com> <20080117211437.GA7573@c2.user-mode-linux.org> <20080117214150.GA25872@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117214150.GA25872@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 01:41:50PM -0800, Venki Pallipadi wrote:
> > And while we're on the subject, what's the deal with these, in
> > include/asm-x86/io.h?
> > 
> > #define ioremap_wc ioremap_wc
> > #define unxlate_dev_mem_ptr unxlate_dev_mem_ptr
> > 
> 
> If archs want to override the defaults for these two functions, they define
> the above and then include asm-generic/iomap.h.

That wasn't really the question.

#define X X

is a no-op, yes?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
