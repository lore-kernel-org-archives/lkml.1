Return-Path: <linux-kernel-owner+w=401wt.eu-S936217AbZLQPLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936217AbZLQPLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935742AbZLQPLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:11:10 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59655 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935609AbZLQPLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:11:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EDkfStngCJR95Vzz9Q5uvrsssRN2p/VHwei7tC0tb1UZs6+vf6pz0rTcgebcllJgnA
         SNMj5tUepUdws9yOhg6GoXCiZ7aAPx+kyFpPLituOnSQxCIDgV21YiK+O3L1RM9WwKgw
         35FABQvkRoR9ZfIq1KnMiTp3A0HdIcp9SlewY=
Date: Thu, 17 Dec 2009 18:11:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Michal Marek <mmarek@suse.cz>,
       Andrew Randrianasulu <randrik_a@yahoo.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] hw-breakpoint: Fix hardware breakpoints -> perf
	events dependency
Message-ID: <20091217151102.GA5414@lenovo>
References: <1261009575-7496-1-git-send-regression-fweisbec@gmail.com> <1261010034-7786-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261010034-7786-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 01:33:54AM +0100, Frederic Weisbecker wrote:
...
> 
> This fixes the following kind of build errors:
> 
> In file included from arch/x86/kernel/hw_breakpoint.c:31:
> include/linux/hw_breakpoint.h: In function 'hw_breakpoint_addr':
> include/linux/hw_breakpoint.h:39: error: 'struct perf_event' has no member named 'attr'
> include/linux/hw_breakpoint.h: In function 'hw_breakpoint_type':
> include/linux/hw_breakpoint.h:44: error: 'struct perf_event' has no member named 'attr'
> include/linux/hw_breakpoint.h: In function 'hw_breakpoint_len':
> include/linux/hw_breakpoint.h:49: error: 'struct perf_event' has no member named 'attr'
> include/linux/hw_breakpoint.h: In function 'counter_arch_bp':
> include/linux/hw_breakpoint.h:85: error: 'struct perf_event' has no member named 'hw'
> 
> v2: Select also ANON_INODES from x86, required for perf
> 
...

Thanks Frederic! It did trick for me.

	-- Cyrill
