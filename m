Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbZJUGL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbZJUGL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 02:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZJUGL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 02:11:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52272 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZJUGL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 02:11:27 -0400
Date: Wed, 21 Oct 2009 08:11:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
Message-ID: <20091021061109.GA27195@elte.hu>
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <4ADD48D1.1040701@kernel.org> <alpine.LSU.2.00.0910200756300.8582@wotan.suse.de> <4ADD54D4.70808@kernel.org> <4ADD5530.3050107@kernel.org> <alpine.LSU.2.00.0910200826220.8582@wotan.suse.de> <4ADDC69A.5000701@suse.com> <4ADDCDED.6060706@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADDCDED.6060706@suse.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Mahoney <jeffm@suse.com> wrote:

> This version fixes a build issue (__alignof__(unsigned long)) and 
> fixes the percpu lookup to be usd = percpu array pointer, usd[i] = 
> actual variable.

Before applying this part-workaround i'd like to see confirmation that 
the IA64 limitation is being fixed. It would be bad for such bugs to pop 
up again and again in the future, with a 2 months bug fixing latency.

	Ingo
