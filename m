Return-Path: <linux-kernel-owner+w=401wt.eu-S1762421AbZEOK55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762421AbZEOK55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762168AbZEOK5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:57:46 -0400
Received: from Cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:62888 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761475AbZEOK5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:57:45 -0400
From: Frans Pop <elendil@planet.nl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: idle: fix init-time TSC check regression
Date: Fri, 15 May 2009 12:57:43 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Janne Kulmala <janne.t.kulmala@tut.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       johnstul@us.ibm.com
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com> <alpine.LFD.2.00.0905142217340.3561@localhost.localdomain> <alpine.LFD.2.00.0905141750100.24833@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905141750100.24833@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905151257.45285.elendil@planet.nl>
X-OriginalArrivalTime: 15 May 2009 10:57:45.0595 (UTC) FILETIME=[FA55A4B0:01C9D54B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 May 2009, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
>
> A previous 2.6.30 patch, a71e4917dc0ebbcb5a0ecb7ca3486643c1c9a6e2,
> (ACPI: idle: mark_tsc_unstable() at init-time, not run-time)
> erroneously disabled the TSC on systems that did not actually
> have valid deep C-states.
>
> Move the check after the deep-C-states are validated,
> via new helper, tsc_check_state(), hich replaces tsc_halts_in_c().
>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

OK on both my desktop (which had the regression) and laptop.

Tested-by: Frans Pop <elendil@planet.nl>

(Tested together with the 2 patches you sent later.)

Cheers,
FJP
