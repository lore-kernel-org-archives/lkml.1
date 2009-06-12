Return-Path: <linux-kernel-owner+w=401wt.eu-S1763845AbZFLJw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763845AbZFLJw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbZFLJwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:52:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42553 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbZFLJwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:52:49 -0400
Date: Fri, 12 Jun 2009 12:00:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] HWPOISON: define VM_FAULT_HWPOISON to 0 when feature is disabled
Message-ID: <20090612100050.GC25568@one.firstfloor.org>
References: <20090611142239.192891591@intel.com> <20090611144430.414445947@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611144430.414445947@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:22:40PM +0800, Wu Fengguang wrote:
> So as to eliminate one #ifdef in the c source.
> 
> Proposed by Nick Piggin.

Some older gccs didn't eliminate string constants for this,
please check you don't get the string in the object file with 
gcc 3.2 with the CONFIG disabled now.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
