Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbYAIH6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbYAIH6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYAIH6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:58:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54474 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYAIH6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:58:10 -0500
Date: Wed, 9 Jan 2008 07:58:03 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCHv3] kprobes: Introduce kprobe_handle_fault()
Message-ID: <20080109075803.GB32560@infradead.org>
References: <1199737486.7666.12.camel@brick> <18307.64807.204087.375733@cargo.ozlabs.ibm.com> <1199833324.6424.12.camel@brick> <1199852360.6424.39.camel@brick> <20080109061408.GA9486@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109061408.GA9486@osiris.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 07:14:08AM +0100, Heiko Carstens wrote:
> I like this better (not including any other changes):
> 
> 	if (!user_mode(regs) && !preemptible() && kprobe_running())
> 		return kprobe_fault_handler(regs, trapnr);

seconded.

