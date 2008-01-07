Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYAGWoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYAGWoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 17:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYAGWof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 17:44:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:54538 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYAGWoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 17:44:34 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Mark Lord <lkml@rtr.ca>
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Date: Mon, 7 Jan 2008 17:43:03 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, abelay@novell.com,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, rjw@sisk.pl
References: <20071130142058.816d1693.akpm@linux-foundation.org> <200801071412.59964.lenb@kernel.org> <47829AA7.3020304@rtr.ca>
In-Reply-To: <47829AA7.3020304@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801071743.04192.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008 16:33, Mark Lord wrote:
> Len Brown wrote:
> > 1. Why does VMware need max_cstate=1 to load quickly?
> ..
> 
> Eh?  Nothing to do with "loading" anything,
> but rather it's simple responsiveness to guest keyboard
> input that we're experiencing trouble with.
> The guest OS is probably "broken" in that regard,
> but setting max_cstate=1 makes it usable here.

okay, then when vmware is loaded, but idle, please run powertop
http://www.lesswatts.org/projects/powertop

and report what you see for C-states, P-states
and wakeup sources.


> > 2. Why does the "max_csate=1" workaround help only
> >    on the dual-core boxes, while the single-core
> >    boxes still fail to load quickly?
> ..
> 
> Eh?  Setting max_cstate=1 helps on both single/dual core
> boxes/kernels here.  The alternative (newer) latency thing
> (that requires a custom kernel module to change on the fly)
> is the thing that had no effect at all on our single-core box,
> but did seem to help the dual-core more (not verified completely
> on dual-core though).

please report the contents of 
cat /proc/acpi/processor/CPU*/power
for both systems when the C-states are not limited.

what latency limit did you specific to the latency I/F?

thanks,
-Len
