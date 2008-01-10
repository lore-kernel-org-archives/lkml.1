Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYAJDQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYAJDQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 22:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbYAJDQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 22:16:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbYAJDQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 22:16:44 -0500
Message-ID: <47858DDE.4010706@redhat.com>
Date: Wed, 09 Jan 2008 22:15:42 -0500
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
Subject: Re: [PATCH 2/2] kprobe: remove preempt_enable/disable from	kprobe_handle_fault()
References: <1199737486.7666.12.camel@brick>	 <18307.64807.204087.375733@cargo.ozlabs.ibm.com>	 <1199833324.6424.12.camel@brick> <1199852360.6424.39.camel@brick>	 <20080109061408.GA9486@osiris.ibm.com> <1199859742.6424.44.camel@brick>	 <1199916062.6424.60.camel@brick>  <20080109231620.GA9002@osiris.ibm.com> <1199925900.6424.86.camel@brick>
In-Reply-To: <1199925900.6424.86.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> This patch removes the preempt_disable/enable pair around kprobe_running
> which was originally added to avoid the assertion from smp_processor_id
> which would be hit an asertion if preemption was enabled.
> 
> Kprobes can not be running if we are preemptible, so test explicitly
> for preemption and bail out before hitting kprobe_running().
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Tested on x86-64.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

