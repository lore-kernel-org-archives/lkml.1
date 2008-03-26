Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbYCZQgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbYCZQgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbYCZQf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:35:58 -0400
Received: from relay2.sgi.com ([192.48.171.30]:57619 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752426AbYCZQf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:35:57 -0400
Date: Wed, 26 Mar 2008 09:34:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Bart Van Assche <bart.vanassche@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: quicklists confuse meminfo
In-Reply-To: <e2e108260803260337j4175b3emc3304b67b8314bea@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803260929350.27909@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> 
 <20080309114640.85c9c3eb.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com> 
 <200803111507.20870.nickpiggin@yahoo.com.au> 
 <e2e108260803210552i4cdef6a5qf8f5076eaac2cf03@mail.gmail.com> 
 <20080321144517.GA1545@elte.hu>  <e2e108260803260045q37792686l80ddb421f2e67c6f@mail.gmail.com>
  <20080326081349.GA8159@elte.hu> <e2e108260803260337j4175b3emc3304b67b8314bea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Bart Van Assche wrote:

> Thanks to everyone who worked on this. By the way, I have asked Albert 
> Calahan, the procps maintainer, to fix the free/top/vmstat tools such 
> that these take recently added /proc/meminfo fields into account and 
> display correct values on recent 2.6 kernels. See also 
> http://bugzilla.kernel.org/show_bug.cgi?id=9991 and 
> http://marc.info/?l=linux-mm&m=120496901605830&w=2.

Be aware that some distros have hacked their meminfo (proc and 
/sys/devices/system/node/node*/meminfo) output to be more compatible with 
recent 2.6 kernels but not updated to the new ZVC counter scheme. On those 
kernels (<2.6.17) counters may show weird values and the sum of the per 
node counters in sysfs may not yield the same amount shown in 
/proc/meminfo.
