Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbYJWUUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbYJWUUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYJWUUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:20:09 -0400
Received: from verein.lst.de ([213.95.11.210]:41880 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYJWUUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:20:07 -0400
Date: Thu, 23 Oct 2008 22:19:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: wierd new config options
Message-ID: <20081023201949.GA29258@lst.de>
References: <20081023181818.GA25430@lst.de> <4900D7AE.3010505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4900D7AE.3010505@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 03:59:42PM -0400, Rik van Riel wrote:
> Christoph Hellwig wrote:
> >Why is UNEVICTABLE_LRU and option?  Is there any rason to turn it off or
> >is this just to confuse users?
> 
> Since the swapout code itself is already configurable with
> CONFIG_SWAP, I do believe we want to be able to config out
> the unevictable LRU code.
> 
> I guess it could be argued that maybe CONFIG_UNEVICTABLE_LRU
> should just be folded into CONFIG_SWAP...

Sounds like a good plan.

