Return-Path: <linux-kernel-owner+w=401wt.eu-S934475AbXEGRaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475AbXEGRaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966045AbXEGRaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:30:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45065 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965752AbXEGRaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:30:17 -0400
Date: Mon, 7 May 2007 10:30:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: "Yu, Fenghua" <fenghua.yu@intel.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add percpu smp cacheline align section
In-Reply-To: <20070507171129.GA21638@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0705071029470.5447@schroedinger.engr.sgi.com>
References: <33E1C72C74DBE747B7B59C1740F7443701A2F0AB@orsmsx417.amr.corp.intel.com>
 <20070505001222.GA26142@linux-os.sc.intel.com>
 <Pine.LNX.4.64.0705050951040.27326@schroedinger.engr.sgi.com>
 <20070507171129.GA21638@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Siddha, Suresh B wrote:

> > Ummm... The per cpu area is for exclusive use of a particular processor.
> > If there is contention in the per cpu area then a data object needs to be
> > removed from the per cpu area because the object is *not* accessed only
> > from a certain cpu.
> 
> Christoph, This data(that is being accessed by other cpus) also needs
> to be defined for each cpu and as such it is getting appended (and
> clearly seperated in a different section) to the data which is accessed
> only by the local cpu.
> 
> Not sure what your concern is.

Call this area "cpu shared" or so?

