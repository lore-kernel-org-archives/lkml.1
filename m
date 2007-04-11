Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbXDKSP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbXDKSP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXDKSP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:15:27 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55093 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbXDKSP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:15:26 -0400
Date: Wed, 11 Apr 2007 11:06:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: eranian@hpl.hp.com, Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, lenb@kernel.org
Subject: Re: 2.6.21-rc6-mm1
Message-Id: <20070411110659.d6ab6b39.akpm@linux-foundation.org>
In-Reply-To: <200704111239.06259.ak@suse.de>
References: <653FFBB4508B9042B5D43DC9E18836F539ADFB@scsmsx415.amr.corp.intel.com>
	<20070411001513.GA2975@linux-os.sc.intel.com>
	<20070411052007.GA24056@frankl.hpl.hp.com>
	<200704111239.06259.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 12:39:05 +0200
Andi Kleen <ak@suse.de> wrote:

> > The next kernel patch for Perfmon will not make use of the idle notification
> > anymore on any platform.
> 
> What do you use instead? 
> 
> I've been actually thinking to add idle notifier support to oprofile to correct
> for the "perfctr doesn't tick in idle" issue which makes numbers not add up to 100%. 
> A lot of people are currently running idle=poll to work around this and that is very
> wasteful.

There was some plan to be able to switch idle handlers at runtime, so one can select
idle=poll just during oprofile operation.  I'm not sure what happened to that idea.
