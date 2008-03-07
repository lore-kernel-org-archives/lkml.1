Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbYCGFhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbYCGFhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 00:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYCGFhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 00:37:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbYCGFha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 00:37:30 -0500
Date: Fri, 7 Mar 2008 06:37:28 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 2/3] slab: introduce SMP alignment
Message-ID: <20080307053728.GL21185@wotan.suse.de>
References: <20080303200355.GB8974@wotan.suse.de> <Pine.LNX.4.64.0803031208400.16049@schroedinger.engr.sgi.com> <20080303201211.GE8974@wotan.suse.de> <Pine.LNX.4.64.0803031216430.3110@schroedinger.engr.sgi.com> <20080303202411.GH8974@wotan.suse.de> <Pine.LNX.4.64.0803031327330.4375@schroedinger.engr.sgi.com> <20080307043700.GI21185@wotan.suse.de> <Pine.LNX.4.64.0803062108210.1143@schroedinger.engr.sgi.com> <20080307051944.GJ21185@wotan.suse.de> <Pine.LNX.4.64.0803062120410.1215@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803062120410.1215@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 09:26:24PM -0800, Christoph Lameter wrote:
> Internode alignment is 4k. If you need an object aligned like that then it 
> may be better to go to the page allocator.

But you don't need an object aligned like that unless you are VSMP.
