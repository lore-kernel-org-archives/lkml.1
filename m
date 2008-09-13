Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbYIMRDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbYIMRDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 13:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYIMRDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 13:03:25 -0400
Received: from gw.goop.org ([64.81.55.164]:56142 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYIMRDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 13:03:24 -0400
Message-ID: <48CBF25B.5030107@goop.org>
Date: Sat, 13 Sep 2008 10:03:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
CC: arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.819383000@linux-os.sc.intel.com>
In-Reply-To: <20080913000051.819383000@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venkatesh Pallipadi wrote:
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: [patch 1/2] x86: track memtype for RAM in page struct
>
> Track the memtype for RAM pages in page struct instead of using the memtype
> list. This avoids the explosion in the number of entries in memtype list
> (of the order of 20,000 with AGP) and makes the PAT tracking simpler. We are
> using PG_arch_1 bit in page->flags.
>   

Please define PG_arch_1 a proper name so that its easy to tell its being
used just by looking at page-flags.h.

    J
