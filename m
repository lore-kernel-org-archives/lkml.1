Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbYAJMw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbYAJMw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbYAJMwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:52:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54600 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYAJMwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:52:20 -0500
Date: Thu, 10 Jan 2008 13:50:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, tony.luck@intel.com,
       Paul Mackerras <paulus@samba.org>, David Wilder <dwilder@us.ibm.com>,
       jkenisto@us.ibm.com
Subject: Re: [PATCH 1/2] kprobes: Introduce kprobe_handle_fault()
Message-ID: <20080110125050.GA21980@elte.hu>
References: <1199737486.7666.12.camel@brick> <18307.64807.204087.375733@cargo.ozlabs.ibm.com> <1199833324.6424.12.camel@brick> <1199852360.6424.39.camel@brick> <20080109061408.GA9486@osiris.ibm.com> <1199859742.6424.44.camel@brick> <1199916062.6424.60.camel@brick> <20080109231620.GA9002@osiris.ibm.com> <1199925898.6424.85.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199925898.6424.85.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Use a central kprobe_handle_fault() inline in kprobes.h to remove all 
> of the arch-dependant, practically identical implementations in avr32, 
> ia64, powerpc, s390, sparc64, and x86.

i guess this should be done via -mm, because it changes all 
architectures.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
