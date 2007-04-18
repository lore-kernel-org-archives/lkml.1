Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbXDRAsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbXDRAsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 20:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030957AbXDRAsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 20:48:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46267 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753232AbXDRAsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 20:48:31 -0400
Date: Tue, 17 Apr 2007 17:48:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] slab: resize the alien caches too
In-Reply-To: <20070418004418.GA30721@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0704171747130.2143@schroedinger.engr.sgi.com>
References: <20070418004418.GA30721@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Siddha, Suresh B wrote:

> While going through the slab code, I observed that alien caches are
> not getting resized, when user changes the slab tunables. Appended patch
> tries to fix this. Please review and let me know if I missed anything.

Let it be. We have not resized the alien caches ever and doing so may 
cause serious memory usage. Size is hardcoded to 12 anyways.

