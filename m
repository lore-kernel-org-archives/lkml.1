Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbXEYQTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbXEYQTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763453AbXEYQSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:18:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763432AbXEYQSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:18:43 -0400
Date: Fri, 25 May 2007 12:18:37 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@novell.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Multiple free during oprofile unload
Message-ID: <20070525161837.GA26105@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@novell.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <4656FA04.5000403@redhat.com> <200705251742.35692.ak@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705251742.35692.ak@novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 05:42:35PM +0200, Andi Kleen wrote:
 > 
 > >         for_each_possible_cpu(i) {
 > >                 kfree(cpu_msrs[i].counters);
 > >                 cpu_msrs[i].counters = NULL;
 > >                 kfree(cpu_msrs[i].controls);
 > >                 cpu_msrs[i].controls = NULL;
 > >         }
 > > 
 > > Seems the patch makes all the cpu_msrs[] point to the same area?
 > 
 > Yes I forgot to fix the free path. Will submit a patch.
 > 
 > BTW that is why I'm not so happy with you being so trigger happy with stable
 > submissions.

So what, the alternative is leave oprofile busted in 2.6.21.x even longer?

	Dave

-- 
http://www.codemonkey.org.uk
