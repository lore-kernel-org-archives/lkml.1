Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbZD1IRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbZD1IRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbZD1IRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:17:17 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44396 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286AbZD1IRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:17:15 -0400
Subject: Re: meminfo Committed_AS underflows
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ebmunson@us.ibm.com,
       mel@linux.vnet.ibm.com, cl@linux-foundation.org, stable@kernel.org
In-Reply-To: <20090427202707.9d36ce8a.akpm@linux-foundation.org>
References: <20090415084713.GU7082@balbir.in.ibm.com>
	 <20090427132722.926b07f1.akpm@linux-foundation.org>
	 <20090428092400.EBB6.A69D9226@jp.fujitsu.com>
	 <20090427202707.9d36ce8a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 01:17:11 -0700
Message-Id: <1240906631.29485.75.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-27 at 20:27 -0700, Andrew Morton wrote:
> There's potential here for weird performance regressions, so I think
> that if we do this in mainline, we should wait a while (a few weeks?)
> before backporting it.
> 
> Do we know how long this bug has existed for?  Quite a while, I
> expect?

Yeah, we didn't notice it until a recent enterprise distro got a config
with NR_CPUS=1024.  That opened the window up in a major way because of
the way we calculated the threshold.

-- Dave

