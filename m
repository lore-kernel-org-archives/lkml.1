Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbXEDGqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbXEDGqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 02:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbXEDGqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 02:46:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:44225 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbXEDGqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 02:46:18 -0400
Date: Thu, 3 May 2007 23:45:53 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, kenchen@google.com, agl@us.ibm.com,
       hermes@gibson.dropbear.id.au, clameter@sgi.com
Subject: Re: + per-cpuset-hugetlb-accounting-and-administration.patch added to -mm tree
Message-ID: <20070504064553.GK26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, mm-commits@vger.kernel.org,
	kenchen@google.com, agl@us.ibm.com, hermes@gibson.dropbear.id.au,
	clameter@sgi.com
References: <200705040104.l4414YFR026322@shell0.pdx.osdl.net> <20070503183821.b75e8f57.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503183821.b75e8f57.pj@sgi.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 06:38:21PM -0700, Paul Jackson wrote:
> Adding Christoph Lameter <clameter@sgi.com> to the cc list, as he knows
> more about hugetlb pages than I do.
> This patch strikes me as a bit odd.
> Granted, it's solving what could be a touchy problem with a fairly
> simple solution, which is usually a Good Thing(tm).
> However, the idea that different tasks would see different values for
> the following fields in /proc/meminfo:
> 	HugePages_Total:     0
> 	HugePages_Free:      0
> strikes me as odd, and risky.  I would have thought that usually, all
> tasks in the system should see the same values in the files in /proc
> (as opposed to the files in particular task subdirectories /proc/<pid>.)
> This patch strikes me as a bit of a hack, good for compatibility, but
> hiding a booby trap that will bite some user code in the long run.
> But I'm not enough of an expert to know what the right tradeoffs are
> in this matter.

The semantics of the global /proc/meminfo should not change; a separate
per-cpuset reporting mechanism should really be used.


-- wli
