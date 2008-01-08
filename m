Return-Path: <linux-kernel-owner+w=401wt.eu-S1762304AbYAHREx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762304AbYAHREx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbYAHREo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:04:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbYAHREn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:04:43 -0500
Message-ID: <4783ACD3.5080700@redhat.com>
Date: Tue, 08 Jan 2008 12:03:15 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, tony.luck@intel.com,
       paulus@samba.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHv2] kprobes: Introduce is_kprobe_fault()
References: <1199737486.7666.12.camel@brick>
In-Reply-To: <1199737486.7666.12.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for good work!

Harvey Harrison wrote:
> Use a central is_kprobe_fault() inline in kprobes.h to remove all
> of the arch-dependant, practically identical implementations in
> avr32, ia64, powerpc, s390, sparc64, and x86.
> 
> avr32 was the only arch without the preempt_disable/enable pair
> in its notify_page_fault implementation.
> 
> This uncovered a possible bug in the s390 version as that purely
> copied the x86 version unconditionally passing 14 as the trapnr
> rather than the error_code parameter.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>


I tested it on x86-64.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

