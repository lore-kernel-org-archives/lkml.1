Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbXIEDsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbXIEDsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 23:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbXIEDsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 23:48:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39422 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518AbXIEDsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 23:48:24 -0400
Date: Tue, 4 Sep 2007 20:48:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mike Travis <travis@sgi.com>, steiner@sgi.com, ak@suse.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamalesh@linux.vnet.ibm.com
Subject: Re: [PATCH 3/6] x86: Convert cpu_sibling_map to be a per cpu variable
 (v2) (fwd)
In-Reply-To: <20070904141055.e00a60d7.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709042047380.7231@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0708312028400.24049@schroedinger.engr.sgi.com>
 <46DDC017.4040301@sgi.com> <20070904141055.e00a60d7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2007, Andrew Morton wrote:

> > My question though, would include/linux/smp.h be the appropriate place for
> > the above define?  (That is, if the above approach is the correct one... ;-)
> 
> It'd be better to convert the unconverted architectures?

That is certainly the cleanest solution. Maybe we can only convert the 
variables used in the scheduler that way?

