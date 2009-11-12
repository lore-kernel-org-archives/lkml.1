Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZKLW74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZKLW74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZKLW7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:59:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56015 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbZKLW7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:59:51 -0500
Message-ID: <4AFC92DD.3020105@zytor.com>
Date: Thu, 12 Nov 2009 14:57:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Mike Travis <travis@sgi.com>,
       Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
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
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com> <4AEEBE65.3070202@linux.intel.com> <4AEF3143.2030701@sgi.com> <20091112222200.GA19109@redhat.com>
In-Reply-To: <20091112222200.GA19109@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2009 02:22 PM, Dave Jones wrote:
> 
> But I don't disagree with Andi either, that it's not particularly useful,
> and we can get all this from userspace in /proc/cpuinfo, or x86info.
> 

I personally don't think it's useful at all.  It gives information about
the processor which can be obtained from other sources.  What we want is
enough information that the CPU can be unambiguously identified, so that
when someone posts dmesg we can tell what machine they came from.

	-hpa
