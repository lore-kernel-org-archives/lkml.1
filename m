Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbYG2OU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbYG2OU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbYG2OUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:20:11 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:35128 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755887AbYG2OUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:20:09 -0400
Date: Tue, 29 Jul 2008 23:18:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Chandru <chandru@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Terry Loftin <terry.loftin@hp.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 5/5] sh: Define elfcorehdr_addr in arch dependent section
Message-ID: <20080729141835.GC902@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Vivek Goyal <vgoyal@redhat.com>, Simon Horman <horms@verge.net.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muli Ben-Yehuda <muli@il.ibm.com>, Tony Luck <tony.luck@intel.com>,
	linux-ia64@vger.kernel.org, Chandru <chandru@in.ibm.com>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	Terry Loftin <terry.loftin@hp.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
References: <20080727234529.GM6175@verge.net.au> <20080728015117.GA12055@verge.net.au> <20080728024526.GB3334@verge.net.au> <20080728034007.GA30450@verge.net.au> <20080728211025.GA9985@redhat.com> <20080728211156.GB9985@redhat.com> <20080728211314.GC9985@redhat.com> <20080728211408.GD9985@redhat.com> <20080728211514.GE9985@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728211514.GE9985@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 05:15:14PM -0400, Vivek Goyal wrote:
> o Move elfcorehdr_addr definition in arch dependent crash dump file. This is
>   equivalent to defining elfcorehdr_addr under CONFIG_CRASH_DUMP instead of
>   CONFIG_PROC_VMCORE. This is needed by is_kdump_kernel() which can be
>   used irrespective of the fact whether CONFIG_PROC_VMCORE is enabled or
>   not.
> 
> o I don't see sh setup code parsing the command line for elfcorehdr_addr. I 
>   am wondering how does vmcore interface work on sh. Anyway, I am atleast
>   defining elfcoredhr_addr so that compilation is not broken on sh.
> 
Hmm, you are correct, it seems like it was either lost in a merge
somewhere or I simply neglected to check it in it when I was testing this
stuff initially. Thanks for noticing!

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
