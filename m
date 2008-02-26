Return-Path: <linux-kernel-owner+w=401wt.eu-S1764842AbYBZVbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764842AbYBZVbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762442AbYBZVa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:30:57 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40895 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762312AbYBZVa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:30:56 -0500
Date: Tue, 26 Feb 2008 15:30:54 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
Message-Id: <20080226153054.48c329cf.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802261306110.10790@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com>
	<20080226114417.c8948b61.pj@sgi.com>
	<alpine.DEB.1.00.0802261306110.10790@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> I don't understand what Oracle has to do with anything here ...

I'm figuring that the risk is high that we broke the existing calls,
when the new MPOL_F_*_NODES flags are not used.

> If you have any examples of unexpected behavior after applying my 
> patchset, please post it and I'll fix it rather quickly.

That won't cut it for Oracle, or other such major applications
using NUMA mempolicy calls.  If we wait for them to report breakage,
it will be a year or two down the road from now, and it would be
another year or two before they could presume the fix was in the
kernel version they were supporting.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
