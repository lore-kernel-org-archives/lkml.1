Return-Path: <linux-kernel-owner+w=401wt.eu-S1763889AbYCGEFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763889AbYCGEFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 23:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYCGEFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 23:05:42 -0500
Received: from mail.suse.de ([195.135.220.2]:34902 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbYCGEFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 23:05:42 -0500
Date: Fri, 7 Mar 2008 05:05:40 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
       dada1@cosmosbay.com
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
Message-ID: <20080307040540.GH21185@wotan.suse.de>
References: <20080306025758.GB27150@wotan.suse.de> <Pine.LNX.4.64.0803061453360.16212@schroedinger.engr.sgi.com> <20080307022355.GB21185@wotan.suse.de> <Pine.LNX.4.64.0803061825120.29527@schroedinger.engr.sgi.com> <20080307023223.GD21185@wotan.suse.de> <Pine.LNX.4.64.0803061841220.29959@schroedinger.engr.sgi.com> <20080307031044.GF21185@wotan.suse.de> <Pine.LNX.4.64.0803061916580.30259@schroedinger.engr.sgi.com> <20080307032251.GG21185@wotan.suse.de> <Pine.LNX.4.64.0803061956390.532@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803061956390.532@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 07:58:06PM -0800, Christoph Lameter wrote:
> On Fri, 7 Mar 2008, Nick Piggin wrote:
> 
> > Where do I argue that it reduces cacheline contention? All arguments
> > I made apply to a UP system equally.
> 
> Huh? I thought you wanted to avoid cacheline alignment on UP to save 
> memory?

We're talking about HWCACHE_ALIGN in this thread. SMP_ALIGN is for
reducing cacheline contention and that's where you can avoid it on UP.


