Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbXDIQkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbXDIQkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbXDIQkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:40:52 -0400
Received: from holomorphy.com ([66.93.40.71]:51308 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbXDIQkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:40:51 -0400
Date: Mon, 9 Apr 2007 09:40:29 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Martin Bligh <mbligh@google.com>,
       Dave Hansen <hansendc@us.ibm.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/4] x86_64: (SPARSE_VIRTUAL doubles sparsemem speed)
Message-ID: <20070409164029.GT2986@holomorphy.com>
References: <20070401071029.23757.78021.sendpatchset@schroedinger.engr.sgi.com> <200704011246.52238.ak@suse.de> <Pine.LNX.4.64.0704020832320.30394@schroedinger.engr.sgi.com> <1175544797.22373.62.camel@localhost.localdomain> <Pine.LNX.4.64.0704021324480.31842@schroedinger.engr.sgi.com> <461169CF.6060806@google.com> <Pine.LNX.4.64.0704021345110.1224@schroedinger.engr.sgi.com> <4614E293.3010908@shadowen.org> <Pine.LNX.4.64.0704051119400.9800@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0704071455060.31468@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704071455060.31468@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 03:06:13PM -0700, Christoph Lameter wrote:
> +/*
> + * Performance Counters and Measurement macros
> + * (C) 2005 Silicon Graphics Incorporated
> + * by Christoph Lameter <clameter@sgi.com>, April 2005
> + *
> + * Counters are calculated using the cycle counter. If a process
> + * is migrated to another cpu during the measurement then the measurement
> + * is invalid.
> + *
> + * We cannot disable preemption during measurement since that may interfere
> + * with other things in the kernel and limit the usefulness of the counters.
> + */

Whatever's going on with the rest of this, I really like this
instrumentation patch. It may be worthwhile to allow pc_start() to be
overridden so things like performance counter MSR's are usable, but
the framework looks very useful.


-- wli
