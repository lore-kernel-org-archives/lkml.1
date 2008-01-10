Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbYAJDRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbYAJDRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 22:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbYAJDQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 22:16:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608AbYAJDQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 22:16:50 -0500
Message-ID: <47858DD9.8020007@redhat.com>
Date: Wed, 09 Jan 2008 22:15:37 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       David Wilder <dwilder@us.ibm.com>, jkenisto@us.ibm.com
Subject: Re: [PATCH 1/2] kprobes: Introduce kprobe_handle_fault()
References: <1199737486.7666.12.camel@brick>	 <18307.64807.204087.375733@cargo.ozlabs.ibm.com>	 <1199833324.6424.12.camel@brick> <1199852360.6424.39.camel@brick>	 <20080109061408.GA9486@osiris.ibm.com> <1199859742.6424.44.camel@brick>	 <1199916062.6424.60.camel@brick>  <20080109231620.GA9002@osiris.ibm.com> <1199925898.6424.85.camel@brick>
In-Reply-To: <1199925898.6424.85.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Use a central kprobe_handle_fault() inline in kprobes.h to remove
> all of the arch-dependant, practically identical implementations in
> avr32, ia64, powerpc, s390, sparc64, and x86.
> 
> avr32 was the only arch without the preempt_disable/enable pair
> in its notify_page_fault implementation.
> 
> This uncovered a possible bug in the s390 version as that purely
> copied the x86 version unconditionally passing 14 as the trapnr
> rather than the error_code parameter.  s390 is changed to pass
> error_code in this patch.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

I tested it on x86-64.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

