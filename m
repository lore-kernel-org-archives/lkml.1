Return-Path: <linux-kernel-owner+w=401wt.eu-S1764947AbZFLNQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764947AbZFLNQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764672AbZFLNPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:15:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:11422 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764894AbZFLNPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:15:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,209,1243839600"; 
   d="scan'208";a="153564563"
Date: Fri, 12 Jun 2009 21:15:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] HWPOISON: define VM_FAULT_HWPOISON to 0 when
	feature is disabled
Message-ID: <20090612131541.GA6751@localhost>
References: <20090611142239.192891591@intel.com> <20090611144430.414445947@intel.com> <20090612100050.GC25568@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612100050.GC25568@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 06:00:50PM +0800, Andi Kleen wrote:
> On Thu, Jun 11, 2009 at 10:22:40PM +0800, Wu Fengguang wrote:
> > So as to eliminate one #ifdef in the c source.
> > 
> > Proposed by Nick Piggin.
> 
> Some older gccs didn't eliminate string constants for this,
> please check you don't get the string in the object file with 
> gcc 3.2 with the CONFIG disabled now.

Well I don't have gcc 3.2 at hand and it's missing from apt source.. 

Thanks,
Fengguang

