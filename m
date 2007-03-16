Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbXCPTtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbXCPTtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbXCPTtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:49:11 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33407 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbXCPTtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:49:09 -0400
Date: Fri, 16 Mar 2007 12:49:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 03/26] Xen-paravirt_ops: use paravirt_nop to consistently mark no-op operations
Message-ID: <20070316194904.GO10574@sequoia.sous-sol.org>
References: <20070301232443.195603797@goop.org> <20070301232526.261284776@goop.org> <20070316094432.GU23174@elte.hu> <45FAE560.10401@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FAE560.10401@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Ingo Molnar wrote:
> > but only as a cleanup of the current open-coded (void *) casts. My 
> > problem with this is that it loses the types. Not that there is much to 
> > check for, but still, this adds some assumptions about how function 
> > calls look like.
> 
> I agree.  I don't generally like this kind of hack, but having a single
> test for "func == paravirt_nop" to look for nop pv_ops in the patcher is
> what tipped the balance.

how about __paravirt_nop_start < func < __paravirt_nop_end  and preserve
the types?

thanks,
-chris
