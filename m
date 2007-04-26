Return-Path: <linux-kernel-owner+w=401wt.eu-S1031280AbXDZPvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031280AbXDZPvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031283AbXDZPvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:51:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:42323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031280AbXDZPvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:51:51 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] change global zonelist order on NUMA v2
Date: Thu, 26 Apr 2007 17:51:37 +0200
User-Agent: KMail/1.9.6
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
       AKPM <akpm@linux-foundation.org>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com> <200704261147.44413.ak@suse.de> <Pine.LNX.4.64.0704260845160.1382@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704260845160.1382@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261751.37656.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007 17:46:35 Christoph Lameter wrote:

> 
> It is not a good idea if node 0 has both DMA and NORMAL memory and normal 
> memory is a small fraction of node memory. In that case lots of 
> allocations get redirected to node 1.

Good point yes. On x86-64 you might even have ZONE_DMA on node 0/1 and NORMAL
only on 3. I guess this needs to be detected somehow.

-Andi


