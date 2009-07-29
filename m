Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbZG2QmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbZG2QmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755663AbZG2QmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:42:01 -0400
Received: from waste.org ([66.93.16.53]:37034 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624AbZG2QmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:42:00 -0400
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or
 mapped vma clearing
From: Matt Mackall <mpm@selenic.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Moussa Ba <moussa.a.ba@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rientjes@google.com, xiyou.wangcong@gmail.com, adobriyan@gmail.com,
       yinghan@google.com, npiggin@suse.de, jaredeh@gmail.com
In-Reply-To: <20090729145839.GB15102@csn.ul.ie>
References: <alpine.DEB.2.00.0907271339070.17425@chino.kir.corp.google.com>
	 <7928e7bd0907271514y699d1de4j54f9c562b94ef0cc@mail.gmail.com>
	 <alpine.DEB.2.00.0907271543420.23587@chino.kir.corp.google.com>
	 <7928e7bd0907271638x5ddbfd2ckba2802338a33765a@mail.gmail.com>
	 <alpine.DEB.2.00.0907271657160.27881@chino.kir.corp.google.com>
	 <4A6F2AF4.6050505@gmail.com>
	 <alpine.DEB.2.00.0907281401150.7140@chino.kir.corp.google.com>
	 <4A6F8115.7000500@gmail.com>
	 <20090728165245.65d5cb23.akpm@linux-foundation.org>
	 <7928e7bd0907281700s13d9937yc3b2933b13cfae9f@mail.gmail.com>
	 <20090729145839.GB15102@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 11:41:07 -0500
Message-Id: <1248885667.4545.2673.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 15:58 +0100, Mel Gorman wrote:
> Total aside, is there potential to really mess with LRU aging by abusing
> clear_refs a lot, partcularly as clear_refs is writable by the process
> owner? Does it matter?

Absolutely. However, it's generally the process owner who will suffer.

-- 
http://selenic.com : development and support for Mercurial and Linux


