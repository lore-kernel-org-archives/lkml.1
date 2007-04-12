Return-Path: <linux-kernel-owner+w=401wt.eu-S1030591AbXDLRqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591AbXDLRqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030524AbXDLRqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:46:38 -0400
Received: from mail.suse.de ([195.135.220.2]:37970 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbXDLRqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:46:36 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Date: Thu, 12 Apr 2007 19:46:22 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
References: <20070411162904.232696302@mvista.com> <20070412100039.00ace23f.akpm@linux-foundation.org> <461E6FA7.5080605@goop.org>
In-Reply-To: <461E6FA7.5080605@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704121946.22534.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 19:43:03 Jeremy Fitzhardinge wrote:
> Andrew Morton wrote:
> > hm.  People (ab)use sched_clock() for all sorts of things nowadays.  I wouldn't
> > do anything to degrade it just on behalf of printk-timestamping.
> >   
> 
> printk was the only non-scheduler-ish use I could find.  Are there others?

iirc some of the out of tree tracing toolkits used it at least.

-Andi
