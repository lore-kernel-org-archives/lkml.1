Return-Path: <linux-kernel-owner+w=401wt.eu-S932296AbYCGC1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbYCGC1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 21:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759153AbYCGC1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 21:27:13 -0500
Received: from relay2.sgi.com ([192.48.171.30]:41771 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757590AbYCGC1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 21:27:11 -0500
Date: Thu, 6 Mar 2008 18:26:49 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
       dada1@cosmosbay.com
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
In-Reply-To: <20080307022355.GB21185@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803061825120.29527@schroedinger.engr.sgi.com>
References: <20080303201701.GF8974@wotan.suse.de>
 <Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
 <20080305000637.GA1510@wotan.suse.de> <20080304.161003.129716254.davem@davemloft.net>
 <Pine.LNX.4.64.0803051257030.30742@schroedinger.engr.sgi.com>
 <20080306025758.GB27150@wotan.suse.de> <Pine.LNX.4.64.0803061453360.16212@schroedinger.engr.sgi.com>
 <20080307022355.GB21185@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Nick Piggin wrote:

> That's just because you (apparently still) have a misconception about what
> the flag is supposed to be for. It is not for aligning things to the start
> of a cacheline boundary. It is not for avoiding false sharing on SMP. It

The alignment of the object to the start of a cacheline is the obvious 
meaning and that is also reflected in the comment in slab.h.

