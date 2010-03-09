Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0CIUOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:14:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755248Ab0CIUOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:14:39 -0500
Date: Tue, 9 Mar 2010 12:13:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Corey Minyard <minyard@acm.org>
Cc: Jean Delvare <jdelvare@suse.de>, torvalds@linux-foundation.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Wilck <martin.wilck@ts.fujitsu.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Gary Smith <gasmith@redhat.com>
Subject: Re: [PATCH 1/4] IPMI: Add parameter to limit CPU usage in kipmid
Message-Id: <20100309121359.40766d99.akpm@linux-foundation.org>
In-Reply-To: <4B96A633.2080207@acm.org>
References: <20100303161438.GA17623@minyard.local>
	<201003091305.58136.jdelvare@suse.de>
	<4B96A633.2080207@acm.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Mar 2010 13:49:07 -0600
Corey Minyard <minyard@acm.org> wrote:

> Jean Delvare wrote:
> > Hi Corey, Linus,
> >
> > On Wednesday 03 March 2010 05:14:38 pm Corey Minyard wrote:
> >   
> >> From: Martin Wilck <martin.wilck@ts.fujitsu.com>
> >>
> >> In some cases kipmid can use a lot of CPU.  This adds a way to tune
> >> the CPU used by kipmid to help in those cases.  By setting
> >> kipmid_max_busy_us to a value between 100 and 500, it is possible to
> >> bring down kipmid CPU load to practically 0 without loosing too much
> >> ipmi throughput performance.  Not setting the value, or setting the
> >> value to zero, operation is unaffected.
> >>
> >> Signed-off-by: Martin Wilck <martin.wilck@ts.fujitsu.com>
> >> Cc: Jean Delvare <jdelvare@suse.de>
> >> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> >> ---
> >> This patch has been discussed quite a bit, and I believe all issues with it
> >> have been resolved.  It's not great, but nobody has a better way to handle
> >> the problem.
> >>     
> >
> > I still can't see this patch in Linus' tree as of 2.6.34-rc1. It has been 
> > waiting for sooo long already, can we finally get it in? Linus, will you apply 
> > it? Or should it go through Andrew?
> >   
> It's already in Andrew's patches.  It would be good if this could go in 
> for 2.6.34, I think it has been through enough review and such.

yup, I have it queued for 2.6.34.  -rc1 caught me napping so some
scrambling is happening.

