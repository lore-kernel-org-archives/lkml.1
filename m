Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbYASVjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbYASVjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 16:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYASVjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 16:39:09 -0500
Received: from relay2.sgi.com ([192.48.171.30]:42701 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751270AbYASVjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 16:39:08 -0500
Message-ID: <47926DFA.5020601@sgi.com>
Date: Sat, 19 Jan 2008 13:39:06 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: Add config variables for SMP_MAX
References: <20080118183011.354965000@sgi.com> <20080118183011.917801000@sgi.com> <20080119145243.GA27974@elte.hu>
In-Reply-To: <20080119145243.GA27974@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * travis@sgi.com <travis@sgi.com> wrote:
> 
>> Adds and increases some config variables to accomodate larger SMP
>> configurations:
>>
>> 	NR_CPUS:      max limit now 4096
>> 	NODES_SHIFT:  max limit now 9
>> 	THREAD_ORDER: max limit now 3
>> 	X86_SMP_MAX:  say Y to enable possible cpus == NR_CPUS
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
> 
> i've bisected a boot failure down to this patch (sans the THREAD_ORDER 
> bits): it causes an instant reboot of the 64-bit kernel upon bootup. 
> Failing config attached.
> 
> 	Ingo
> 

Thanks Ingo! 

I've pulled the THREAD_ORDER change from my next version of the patch.
Seems SMP_MAX is just not ready for prime time yet.

One problem that I'm having appears to be that the !NUMA config of the
current -mm version also doesn't boot so I haven't been able to verify
that.  (At least it doesn't seem to make it worse... ;-)

Thanks,
Mike
