Return-Path: <linux-kernel-owner+w=401wt.eu-S1761193AbXHTTlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193AbXHTTlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760794AbXHTTlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:41:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48402 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756264AbXHTTlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:41:36 -0400
Date: Mon, 20 Aug 2007 12:41:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Simple Performance Counters: SLUB instrumentation
In-Reply-To: <20070818032015.GA28293@Krystal>
Message-ID: <Pine.LNX.4.64.0708201239070.29624@schroedinger.engr.sgi.com>
References: <1185924312685-git-send-email-clameter@sgi.com>
 <20070817162154.GB30922@Krystal> <Pine.LNX.4.64.0708171338440.9404@schroedinger.engr.sgi.com>
 <20070818032015.GA28293@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Mathieu Desnoyers wrote:

> > The cpu will definitely not be idle during these measurements and no 
> > frequency scaling is active.
> 
> The problem is that if the cpu is idle _before_ the measurements, the
> frequency will change differently from one cpu to another. Therefore,
> the cycle counters may have large offsets when you start your tests. So,
> if get_cycles() is executed on different CPUs (thread being migrated)
> between the beginning and the end of the test, the results would be
> skewed.

TSC measurements as done by this patch are associated with cpus. The 
skew is irrelevant. Development of this patchset was done on a 
system whose TSC are never synchronized.
