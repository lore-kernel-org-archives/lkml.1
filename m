Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbYJWTQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbYJWTQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYJWTQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:16:45 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:10047 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbYJWTQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:16:45 -0400
Subject: Re: wierd new config options
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
In-Reply-To: <20081023181818.GA25430@lst.de>
References: <20081023181818.GA25430@lst.de>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 15:16:44 -0400
Message-Id: <1224789404.8230.158.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 20:18 +0200, Christoph Hellwig wrote:
> Why is UNEVICTABLE_LRU and option?  Is there any rason to turn it off or
> is this just to confuse users?


We discussed this back when we first submitted the patches.  I
considered the NONRECLAIMABLE/UNEVICTABLE LRU mechanism to be a wee bit
experimental at the time.  I wasn't sure that all platform that do want
memory management would necessarily also want the unevictable lru.  It's
easier for me to build it with the option and remove it later than vice
versa.  If the consensus of the community is that it should always be
enabled, then I'm fine with removing the option.  

Lee

> 
> CORE_DUMP_DEFAULT_ELF_HEADERS is similarly odd, it turns something on
> that break old userspace, this really really should be a sysctl to turn
> on instead of a config option.

