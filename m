Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbZIZQLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbZIZQLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZIZQL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:11:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:51617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZIZQL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:11:28 -0400
Date: Sat, 26 Sep 2009 18:11:49 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: fche@redhat.com (Frank Ch. Eigler)
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
 get to performance counters
Message-ID: <20090926181149.6e5827db@infradead.org>
In-Reply-To: <y0mhbuplmlr.fsf@fche.csb>
References: <20090925122556.2f8bd939@infradead.org>
	<y0mhbuplmlr.fsf@fche.csb>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Sep 2009 12:03:28 -0400
fche@redhat.com (Frank Ch. Eigler) wrote:

> 
> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > [...]
> > There are reasons for kernel code to ask for, and use, performance
> > counters. For example, in CPU freq governors this tends to be a
> > good idea, but there are other examples possible as well of course.
> > 
> > This patch adds the needed bits to do enable this functionality;
> > they have been tested in an experimental cpufreq driver that I'm
> > working on, and the changes are all that I needed to access
> > counters properly. [...]
> 
> For what it's worth, this sort of thing also looks useful from
> systemtap's point of view.
> 
> It appears that the patch assumes that a perf counter instance is to
> be associated with the "current" task.  How do you use this from your
> prototype scheduler?  Do you create/attach a new one for each thread?
> 

your appearance is not correct. A perf counter is either attached to a
task, or to a cpu. I use the later.


--
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
