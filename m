Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbXKZB6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbXKZB6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 20:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbXKZB6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 20:58:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbXKZB6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 20:58:30 -0500
Date: Sun, 25 Nov 2007 20:57:57 -0500
From: Dave Jones <davej@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 23/27] x86: debugctlmsr kconfig
Message-ID: <20071126015757.GA16807@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Roland McGrath <roland@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
References: <20071125215507.4B89226F8C5@magilla.localdomain> <20071125220802.76C2F26F8C5@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071125220802.76C2F26F8C5@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2007 at 02:08:02PM -0800, Roland McGrath wrote:
 > 
 > This adds the (internal) Kconfig macro CONFIG_X86_DEBUGCTLMSR,
 > to be defined when configuring to support only hardware that
 > definitely supports MSR_IA32_DEBUGCTLMSR with the BTF flag.
 > 
 > The Intel documentation says "P6 family" and later processors all have it.
 > I think the Kconfig dependencies are right to have it set for those and
 > unset for others (i.e., when 586 and earlier are supported).

What about the non-Intel vendors ?
Was this msr present on AMD K6 ? Geode? Winchip? VIA C3 ?
If not, then this patch isn't complete. 

	Dave

-- 
http://www.codemonkey.org.uk
