Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbYJaRTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYJaRTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYJaRTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:19:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51985 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYJaRTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:19:35 -0400
Date: Fri, 31 Oct 2008 13:19:16 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: sched domains oddness.
Message-ID: <20081031171916.GB8837@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20081031162443.GA29885@redhat.com> <1225471911.7803.1596.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225471911.7803.1596.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 05:51:51PM +0100, Peter Zijlstra wrote:
 > On Fri, 2008-10-31 at 12:24 -0400, Dave Jones wrote:
 > > The attached dmesg comes from my dual core laptop running 2.6.27
 > > What's up with all the sched domains transitions at the bottom?
 > > This was just a boot up from power off, no suspend/resume or anything funky.
 > 
 > > CPU0 attaching NULL sched-domain.
 > > CPU1 attaching NULL sched-domain.
 > > CPU0 attaching sched-domain:
 > >  domain 0: span 0-1 level MC
 > >   groups: 0 1
 > >   domain 1: span 0-1 level NODE
 > >    groups: 0-1
 > > CPU1 attaching sched-domain:
 > >  domain 0: span 0-1 level MC
 > >   groups: 1 0
 > >   domain 1: span 0-1 level NODE
 > >    groups: 0-1
 > 
 > 3x
 > 
 > looks like someone is triggering rebuild_sched_domains(), is something
 > poking cpusetfs files or flipping between sched_mc settings?
 
cpusetfs doesn't seem to be mounted, and I can't find anything
obvious touching sched_mc

	Dave

-- 
http://www.codemonkey.org.uk
