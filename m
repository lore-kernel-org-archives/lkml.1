Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbXEQScY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbXEQScY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXEQScR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:32:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57016 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbXEQScQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:32:16 -0400
Date: Thu, 17 May 2007 11:23:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: Pavel Emelianov <xemul@sw.ru>, Paul Menage <menage@google.com>,
       Kirill Korotaev <dev@sw.ru>, devel@openvz.org,
       Linux Containers <containers@lists.osdl.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: RSS controller v2 Test results (lmbench )
Message-Id: <20070517112357.7adc4763.akpm@linux-foundation.org>
In-Reply-To: <464C95D4.7070806@linux.vnet.ibm.com>
References: <464C95D4.7070806@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 23:20:12 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> A meaningful container size does not hamper performance. I am in the process
> of getting more results (with varying container sizes). Please let me know
> what you think of the results? Would you like to see different benchmarks/
> tests/configuration results?
> 
> Any feedback, suggestions to move this work forward towards identifying
> and correcting bottlenecks or to help improve it is highly appreciated.

<wakes up>

Memory reclaim tends not to consume much CPU.  Because in steady state it
tends to be the case that the memory reclaim rate (and hopefully the
scanning rate) is equal to the disk IO rate.

Often the most successful way to identify performance problems in there is
by careful code inspection followed by development of exploits.

Is this RSS controller built on Paul's stuff, or is it standalone?

Where do we stand on all of this now anyway?  I was thinking of getting Paul's
changes into -mm soon, see what sort of calamities that brings about.

