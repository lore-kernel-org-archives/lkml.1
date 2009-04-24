Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZDXOWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZDXOWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbZDXOWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:22:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56816 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759497AbZDXOWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:22:04 -0400
Message-ID: <49F1CA6E.5080407@redhat.com>
Date: Fri, 24 Apr 2009 10:19:26 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tim Abbott <tabbott@MIT.EDU>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v3 0/3] Add support for compiling with -ffunction-sections
 -fdata-sections
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain> <alpine.DEB.1.10.0904202010220.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain> <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott wrote:
> On Mon, 20 Apr 2009, Linus Torvalds wrote:
> 
>> I'd be ok with merging it, but I haven't really gotten a strong feeling 
>> that anybody is going to enable it or use it.
> 
> Linus,
> 
> Would you be willing to merge the first 3 patches in this patch series at 
> this point?  I'm resending these patches to resolve some conflicts that 
> was recently introduced.

Hi Tim,

What would you think about posting these patches plus -ffunction-sections/
-fdata-sections patch to -mm tree, -tip tree, or -next tree as
"playable" Ksplice patchset?

If people use it and see it enough stable and useful, those patches
will be automatically pulled into linus kernel.


> To summarize the discussion, there are three uses for this code that have 
> significant interest.
> 
> One is decreasing the kernel size.  Denys Vlasenko has numbers that using 
> the linker's --gc-sections option (for which these patches are a 
> prerequisite) saves 10% of the kernel size when CONFIG_MODULES=n, and 1% 
> when CONFIG_MODULES=y.  Paul Mundt thinks many embedded users would use 
> this if it were available.
> 
> A related use is cleaning up a lot of ifdefs that exist only to decrease 
> the kernel size.  Several developers commented favorably on the direction 
> of using section garbage collection for dead code removal.
> 
> Finally, Ksplice depends on the option added by this patch series.
> 
> The first 3 patches in this patch series fix problems associated with 
> using -ffunction-sections.  As there are some architectures currently 
> using -ffunction-sections, these should ideally be merged now, especially 
> the first patch which involves scattered changes.

If there are actual problems on those arch, I think you'd better post
these patches as bugfixes with bug reports.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

