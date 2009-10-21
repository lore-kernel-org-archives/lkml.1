Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZJUPTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZJUPTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbZJUPTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:19:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:39428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbZJUPTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:19:00 -0400
Message-ID: <4ADF2691.7070304@kernel.org>
Date: Thu, 22 Oct 2009 00:19:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeff Mahoney <jeffm@suse.com>, Jiri Kosina <jkosina@suse.cz>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <4ADD48D1.1040701@kernel.org> <alpine.LSU.2.00.0910200756300.8582@wotan.suse.de> <4ADD54D4.70808@kernel.org> <4ADD5530.3050107@kernel.org> <alpine.LSU.2.00.0910200826220.8582@wotan.suse.de> <4ADDC69A.5000701@suse.com> <4ADDCDED.6060706@suse.com> <20091021061109.GA27195@elte.hu>
In-Reply-To: <20091021061109.GA27195@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Mahoney <jeffm@suse.com> wrote:
> 
>> This version fixes a build issue (__alignof__(unsigned long)) and 
>> fixes the percpu lookup to be usd = percpu array pointer, usd[i] = 
>> actual variable.
> 
> Before applying this part-workaround i'd like to see confirmation that 
> the IA64 limitation is being fixed. It would be bad for such bugs to pop 
> up again and again in the future, with a 2 months bug fixing latency.

I talked with Christoph earlier and he basically said that the
constant can just be bumped up without any ill effect (it would be
great if Tony Luck can confirm this).  So, it's an annoying thing and
in the long term removing would be a good idea but I don't think it's
anything major as long as it blows up during build not runtime.

Thanks.

-- 
tejun
