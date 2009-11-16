Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZKPW6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZKPW6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbZKPW6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:58:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbZKPW6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:58:17 -0500
Message-ID: <4B01D870.3090103@zytor.com>
Date: Mon, 16 Nov 2009 14:55:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] INIT: Limit the number of per cpu calibration bootup
 messages
References: <20091116210718.412792000@alcatraz.americas.sgi.com> <20091116210728.267482000@alcatraz.americas.sgi.com> <20091116212427.GC2221@elte.hu> <4B01C803.1010303@sgi.com> <4B01C8B5.7060903@zytor.com> <4B01D77D.3010006@sgi.com>
In-Reply-To: <4B01D77D.3010006@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2009 02:51 PM, Mike Travis wrote:
> 
> There's also some confusion on whether the boot_cpu_id is the APIC id (ia64)
> or the cpu_index (x86) or some other number (others).   (cpu_index 0 by
> definition will always be the boot cpu.)
> 

This is part of what I said... the whole cpu_index thing is a rather
awkward extra layer of indirection.

But regardless... we have a panarchitectural notion of a cpu ID, and
that is what boot_cpu_id() [or whatever we call it] should refer to.  On
some architectures that will be constant.

	-hpa
