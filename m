Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbYAHFh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbYAHFh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 00:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYAHFhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 00:37:47 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37716 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbYAHFhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 00:37:46 -0500
Date: Tue, 8 Jan 2008 11:07:25 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, tony.luck@intel.com,
       paulus@samba.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHv2] kprobes: Introduce is_kprobe_fault()
Message-ID: <20080108053725.GA8505@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1199737486.7666.12.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199737486.7666.12.camel@brick>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 12:24:46PM -0800, Harvey Harrison wrote:
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

Tested on powerpc.

Tested-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
