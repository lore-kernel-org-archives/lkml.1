Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbXIAOHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbXIAOHZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 10:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXIAOHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 10:07:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbXIAOHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 10:07:13 -0400
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/6] x86: Convert cpu_sibling_map to be a per cpu variable (v2)
Date: Sat, 1 Sep 2007 16:06:48 +0200
User-Agent: KMail/1.9.1
Cc: travis@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
References: <20070824222654.687510000@sgi.com> <20070824222948.851896000@sgi.com> <20070831194903.5d88a007.akpm@linux-foundation.org>
In-Reply-To: <20070831194903.5d88a007.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709011606.49208.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 September 2007 04:49, Andrew Morton wrote:
> On Fri, 24 Aug 2007 15:26:57 -0700 travis@sgi.com wrote:
> > Convert cpu_sibling_map from a static array sized by NR_CPUS to a
> > per_cpu variable.  This saves sizeof(cpumask_t) * NR unused cpus.
> > Access is mostly from startup and CPU HOTPLUG functions.

The patchset was broken anyways even on x86-64 because of the 
ordering issues at early boot Suresh pointed out.

-Andi
