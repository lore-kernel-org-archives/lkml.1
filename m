Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbYKSCrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYKSCrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 21:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYKSCq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 21:46:57 -0500
Received: from ozlabs.org ([203.10.76.45]:60234 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYKSCq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 21:46:56 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18723.31762.522696.647294@cargo.ozlabs.ibm.com>
Date: Wed, 19 Nov 2008 13:38:10 +1100
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/7] Porting dynmaic ftrace to PowerPC
In-Reply-To: <alpine.DEB.1.10.0811180853390.15003@gandalf.stny.rr.com>
References: <20081116212428.938752312@goodmis.org>
	<18720.42209.880409.297291@cargo.ozlabs.ibm.com>
	<alpine.DEB.1.10.0811171035530.2919@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0811180853390.15003@gandalf.stny.rr.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt writes:

> Can I add your Acked-by: to all these patches that I submitted? I'm going 
> to recommit them with a consistent subject (all lower case ppc), but I'm 
> not going to change the patches themselves.
> 
> Would you two be fine with that? Or at least one of you?

My preference would be for the patches to go through the powerpc tree
unless there is a good reason for them to go via another tree.

The style we use for the headline is "powerpc: Add xyz feature" or
"powerpc/subsystem: Fix foo bug".

As for the acked-by, I feel I first need to go through the whole
series again with the changes you have made recently.  Have you
reworked the earlier patches to avoid introducing any bugs, rather
than just fixing the bugs with later patches?  If you haven't, are you
sure that the bugs won't cause any problems in bisecting?

Also, what's the best place to find the latest patch set?

Thanks again for doing all this work.

Paul.
  
