Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbXJ3UkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbXJ3UkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbXJ3UkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:40:06 -0400
Received: from www.tglx.de ([62.245.132.106]:41412 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbXJ3UkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:40:04 -0400
Date: Tue, 30 Oct 2007 21:39:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4 -v5] x86_64 EFI runtime service support: EFI runtime
 services
In-Reply-To: <200710301558.31443.vda.linux@googlemail.com>
Message-ID: <alpine.LFD.0.9999.0710302133090.3300@localhost.localdomain>
References: <1193723743.23935.352.camel@caritas-dev.intel.com> <200710301558.31443.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007, Denys Vlasenko wrote:
> mach_get_cmos_time() is itself an inline, and a _large_ one
> (~20 LOC with macro and function calls).
> 
> Same here, only mach_set_rtc_mmss is 50 LOC, not 20.

It was:) 

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commit;h=3ea9de98deb42d9ea6d1add58e01b66676017c00

	tglx
