Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZAMVd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZAMVd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbZAMVdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:33:18 -0500
Received: from cet.com.ru ([195.178.208.66]:45513 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbZAMVdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:33:18 -0500
Date: Wed, 14 Jan 2009 00:33:16 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
Message-ID: <20090113213316.GB27227@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090112154456.GA27269@redhat.com> <20090112154827.GB20743@ioremap.net> <20090112155108.2646b3ae@lxorguk.ukuu.org.uk> <20090113135246.GA29251@ioremap.net> <20090113140627.507f15e1@lxorguk.ukuu.org.uk> <20090113142423.GA30710@ioremap.net> <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com> <20090113152106.GA1134@ioremap.net> <alpine.DEB.2.00.0901131140340.8522@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901131140340.8522@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 11:46:14AM -0800, David Rientjes (rientjes@google.com) wrote:
> Children are already preferred over the chosen parent task, as I've 
> explained a few times.  When a task is identified for oom kill by the 
> badness heuristics, the oom killer attempts to kill a child that does not 
> share the same mm first, which is exactly what you're asking for here.  If 
> the parent shares the mm, it needs to exit as well before memory freeing 
> may occur.

I really did not investigate why it happend, but oom'ed machine had
killed cgi daemons and parent process itself. And ssh to the heap.
While it should be enough just to kill appropriate daemon. Apparently
things are not that shine as should be.

-- 
	Evgeniy Polyakov
