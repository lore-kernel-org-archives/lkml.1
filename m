Return-Path: <linux-kernel-owner+w=401wt.eu-S966183AbXBPIFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966183AbXBPIFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966184AbXBPIFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:05:43 -0500
Received: from gw.goop.org ([64.81.55.164]:32884 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966183AbXBPIFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:05:42 -0500
Message-ID: <45D565D7.5070303@goop.org>
Date: Fri, 16 Feb 2007 00:05:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
CC: Andi Kleen <ak@muc.de>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Ian Pratt <ian.pratt@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable
 unsupported config options.
References: <20070216022449.739760547@goop.org> <20070216022531.570154735@goop.org> <45D54BD5.8010707@vmware.com> <45D55784.1020000@goop.org> <45D562CC.8000405@vmware.com>
In-Reply-To: <45D562CC.8000405@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:
> On 02/15/2007 11:04 PM, Jeremy Fitzhardinge wrote:
>> HZ - I'm assuming dynticks will appear in the short term, and this will
>> become moot
>
> Doesn't Xen send any non-blocked domain a 100hz alarm implicitly,
> without anyway for the guest to disable it?  I guess you'll have to
> break kernel/hypervisor compatibility if you want dynticks? 

The timer VIRQ will generate events at a fixed 100Hz (which can be
masked, like any other event), but you can also ask for a timer event at
a particular time.  We do this already for tickless idle.

    J
