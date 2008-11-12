Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbYKLP5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbYKLP5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYKLP4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:56:43 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48406 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbYKLP4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:56:42 -0500
Date: Wed, 12 Nov 2008 21:25:29 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/7] kprobes: Add kprobe_insn_mutex and cleanup
	arch_remove_kprobe()
Message-ID: <20081112155529.GA5199@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4919F175.2050009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4919F175.2050009@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 03:56:21PM -0500, Masami Hiramatsu wrote:
> Add kprobe_insn_mutex for protecting kprobe_insn_pages hlist, and remove
> kprobe_mutex from architecture dependent code.
> 
> This allows us to call arch_remove_kprobe() (and free_insn_slot) while holding
> kprobe_mutex.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
