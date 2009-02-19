Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbZBSSEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbZBSSEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZBSSD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:03:59 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:33079 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbZBSSD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:03:59 -0500
Subject: Re: x86, vmi: TSC going backwards check in vmi clocksource
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Zach Amsden <zach@vmware.com>
In-Reply-To: <20090219111822.GN2354@elte.hu>
References: <1234989235.7991.2.camel@alok-dev1>
	 <20090219111822.GN2354@elte.hu>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 19 Feb 2009 10:03:58 -0800
Message-Id: <1235066638.23293.7.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 03:18 -0800, Ingo Molnar wrote:
> * Alok Kataria <akataria@vmware.com> wrote:
> 
> > From: Alok N Kataria <akataria@vmware.com>
> > 
> > Similar to the check for TSC going backwards in the TSC 
> > clocksource, we also need this check for VMI clocksource.
> 
> ok. Precisely what kind of bug/symptoms does this fix?

If the read CYCLES_REAL counter value is less than the cycle_last value,
it may result in time jumps.
I also saw some messages about  process being stuck for more than
120sec, which was traced back to this.

Thanks,
Alok
> 
> 	Ingo

