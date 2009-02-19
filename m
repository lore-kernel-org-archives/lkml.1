Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbZBSARq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbZBSARq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZBSARZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:17:25 -0500
Received: from gw.goop.org ([64.81.55.164]:49601 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbZBSARY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:17:24 -0500
Message-ID: <499CA510.2040406@goop.org>
Date: Wed, 18 Feb 2009 16:17:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok Kataria <akataria@vmware.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/9] x86/paravirt: remove lazy mode in interrupts
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>	 <06944a6dbc4ea222760d39d3d0156e50102f8196.1234988621.git.jeremy.fitzhardinge@citrix.com> <1235004837.6951.6.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1235004837.6951.6.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> On Wed, 2009-02-18 at 14:30 -0800, Jeremy Fitzhardinge wrote:
>   
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Make paravirt_lazy_mode() always return PARAVIRT_LAZY_NONE
>> when in an interrupt.  This prevents interrupt code from
>> accidentally inheriting an outer lazy state, and instead
>> does everything synchronously.  Outer batched operations
>> are left deferred.
>>     
>
> This looks like a good solution, but can you make paravirt_lazy_mode()
> inline?  It doesn't need to be a function call.

Yeah.  I'm not quite sure why it became out of line.

    J

