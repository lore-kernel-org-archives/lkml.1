Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZAGNco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZAGNco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbZAGNce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:32:34 -0500
Received: from relay1.sgi.com ([192.48.179.29]:52558 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752079AbZAGNcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:32:33 -0500
Date: Wed, 7 Jan 2009 07:32:30 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       "Luck, Tony" <tony.luck@intel.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>, Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Message-ID: <20090107133230.GA28694@sgi.com>
References: <57C9024A16AD2D4C97DC78E552063EA35CB95575@orsmsx505.amr.corp.intel.com> <20090106201950.GA3850@sgi.com> <57C9024A16AD2D4C97DC78E552063EA35CB955B4@orsmsx505.amr.corp.intel.com> <1231275441.11687.110.camel@twins> <20090106225054.GB3850@sgi.com> <1231283763.11687.135.camel@twins> <20090107030030.GH3390@wotan.suse.de> <1231313289.11687.172.camel@twins> <20090107094328.GD3850@sgi.com> <1231322037.11687.178.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231322037.11687.178.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Wed, Jan 07, 2009 at 10:53:57AM +0100, Peter Zijlstra wrote:
> 
> Clock state is kept per-cpu, and locked with a spinlock. When we request

Admittedly I have not looked at this possibility too closely, but my initial concern upon looking at sched_clock_cpu() for the UNSTABLE case was the lock_double_clock() and what sort of contention that might cause on larger systems under certain conditions.
