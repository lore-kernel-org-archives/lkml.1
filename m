Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0BWUxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 15:53:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33200 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab0BWUxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 15:53:50 -0500
Message-ID: <4B843F66.6030000@zytor.com>
Date: Tue, 23 Feb 2010 12:49:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       linux-tip-commits@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: linux-next requirements (Was: Re: [tip:x86/ptrace] ptrace: Add
 support for generic PTRACE_GETREGSET/PTRACE_SETREGSET)
References: <20100211195614.886724710@sbs-t61.sc.intel.com>	<tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>	<20100222090710.GA31357@elte.hu>	<20100222203319.8bd497a2.sfr@canb.auug.org.au>	<20100222102745.GJ20844@elte.hu>	<20100222224752.0cbd5807.sfr@canb.auug.org.au>	<4B830BD8.3090600@zytor.com>	<20100223105959.a50dbe11.sfr@canb.auug.org.au> <20100223202030.44DED64C@magilla.sf.frob.com>
In-Reply-To: <20100223202030.44DED64C@magilla.sf.frob.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 12:20 PM, Roland McGrath wrote:
>> Are there any downsides to Roland's patch as far as PARISC is concerned
>> (apart from the loss of some functionality, of course)?
> 
> Kyle ACK'd my parisc patch, and my impression is he wants it to go in
> and does not plan to work on the necessary arch support imminently.
> 
> I think the only visible effect of turning off HAVE_ARCH_TRACEHOOK
> on parisc will be that /proc/pid/syscall is not available.

Added to tip:x86/ptrace.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

