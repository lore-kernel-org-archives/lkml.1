Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZKMIMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZKMIMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbZKMIMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:12:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40506 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZKMIMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:12:06 -0500
Message-ID: <4AFD1497.8040303@zytor.com>
Date: Fri, 13 Nov 2009 00:11:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dave Jones <davej@redhat.com>, Mike Travis <travis@sgi.com>,
       Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
References: <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com> <4AEEBE65.3070202@linux.intel.com> <4AEF3143.2030701@sgi.com> <20091112222200.GA19109@redhat.com> <4AFC92DD.3020105@zytor.com> <20091112231542.GA7129@redhat.com> <20091113080312.GA18054@elte.hu>
In-Reply-To: <20091113080312.GA18054@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2009 12:03 AM, Ingo Molnar wrote:
> 
> * Dave Jones <davej@redhat.com> wrote:
> 
>> In which case..
>>
>> 	Dave
>>
>> --- 
>>
>> Remove the CPU cache size printk's.
>>
>> They aren't useful, and pollute the dmesg output a lot (especially on 
>> machines with many cores). Also the same information can be trivially 
>> found out from userspace.
>>
>> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> Precisely - these are the kind of simple patches i'd like to see.
> 

Indeed.

Acked-by: H. Peter Anvin <hpa@zytor.com>

I'll apply it tomorrow if you don't beat me to it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

