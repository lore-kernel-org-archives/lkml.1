Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbYAVMDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbYAVMDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 07:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYAVMDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 07:03:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYAVMDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 07:03:23 -0500
Date: Tue, 22 Jan 2008 13:02:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com
Subject: Re: [PATCH 0/4] paravirt_ops-64 compile fixes
Message-ID: <20080122120207.GA30271@elte.hu>
References: <1200952133-31581-1-git-send-email-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200952133-31581-1-git-send-email-ehabkost@redhat.com>
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


* Eduardo Habkost <ehabkost@redhat.com> wrote:

> This series contain fixes to make the paravirt_ops code compile and 
> boot on x86_64.
> 
> This is a follow-up for the previous series from Glauber.

thanks Eduardo, i've applied your fixes.

could you perhaps send the missing bits that add the missing 64-bit 
Kconfig entries? Even if the 64-bit side is not functional yet as a real 
guest, it would help us find the build bugs and any runtime regressions 
PARAVIRT might cause on the native 64-bit side of the kernel.

Or is it now just a matter of removing all the depends-on X86_32 bits in 
arch/x86/Kconfig?

	Ingo
