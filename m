Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbXHDREJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbXHDREJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764167AbXHDRDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:03:53 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53749 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760859AbXHDRDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:03:52 -0400
Date: Sat, 4 Aug 2007 21:03:44 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage.
Message-ID: <20070804170344.GA18292@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <1a297b360708022204u4fc7603pb6baebe2bdf28618@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a297b360708022204u4fc7603pb6baebe2bdf28618@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 09:04:51AM +0400, Manu Abraham (abraham.manu@gmail.com) wrote:
> On 7/31/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > TODO list currently includes following main items:
> >     * redundancy algorithm (drop me a request of your own, but it is highly
> >         unlikley that Reed-Solomon based will ever be used - it is too slow
> >         for distributed RAID, I consider WEAVER codes)
> 
> 
> LDPC codes[1][2] have been replacing Turbo code[3] with regards to
> communication links and we have been seeing that transition. (maybe
> helpful, came to mind seeing the mention of Turbo code) Don't know how
> weaver compares to LDPC, though found some comparisons [4][5] But
> looking at fault tolerance figures, i guess Weaver is much better.
> 
> [1] http://www.ldpc-codes.com/
> [2] http://portal.acm.org/citation.cfm?id=1240497
> [3] http://en.wikipedia.org/wiki/Turbo_code
> [4] http://domino.research.ibm.com/library/cyberdig.nsf/papers/BD559022A190D41C85257212006CEC11/$File/rj10391.pdf
> [5] http://hplabs.hp.com/personal/Jay_Wylie/publications/wylie_dsn2007.pdf

LDPC codes require to solve N order matrix over finite field - exactly
the reason I do not want to use Reed-Solomon codes even with optimized
non-Vandermonde matrix. I will investigate LDPC further though.
Turbo codes are like flow cipher compared to RS codes being block
ciphers. Transport media is reliable in data storages, otherwise they
would not even exist.

-- 
	Evgeniy Polyakov
