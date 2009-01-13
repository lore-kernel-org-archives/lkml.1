Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZAMWFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZAMWFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbZAMWFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:05:40 -0500
Received: from cet.com.ru ([195.178.208.66]:56529 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbZAMWFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:05:40 -0500
Date: Wed, 14 Jan 2009 01:05:38 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
Message-ID: <20090113220538.GF27227@ioremap.net>
References: <20090112154827.GB20743@ioremap.net> <20090112155108.2646b3ae@lxorguk.ukuu.org.uk> <20090113135246.GA29251@ioremap.net> <20090113140627.507f15e1@lxorguk.ukuu.org.uk> <20090113142423.GA30710@ioremap.net> <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com> <20090113152106.GA1134@ioremap.net> <alpine.DEB.2.00.0901131140340.8522@chino.kir.corp.google.com> <20090113213316.GB27227@ioremap.net> <alpine.DEB.2.00.0901131336040.17683@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901131336040.17683@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 01:39:01PM -0800, David Rientjes (rientjes@google.com) wrote:
> > I really did not investigate why it happend, but oom'ed machine had
> > killed cgi daemons and parent process itself. And ssh to the heap.
> > While it should be enough just to kill appropriate daemon. Apparently
> > things are not that shine as should be.
> > 
> 
> As previously mentioned, you have all the diagnostic tools at your 
> disposal already:
> 
> 	echo 1 > /proc/sys/vm/oom_dump_tasks
> 
> The badness scoring is straight-forward given that information, so you can 
> diagnose why a specific task was not killed and another was chosen.  You 
> can also use that information to appropriately tune the oom_adj scores to 
> identify your oom killer target preferences.

There is no ssh there, I can not do any diagnostics. I first have to
change oom score for the ssh, but that's a different story.

-- 
	Evgeniy Polyakov
