Return-Path: <linux-kernel-owner+w=401wt.eu-S932475AbYEPPLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbYEPPLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765941AbYEPPJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:09:59 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:42143 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765926AbYEPPJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:09:57 -0400
Date: Fri, 16 May 2008 10:57:18 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       nurhussein@gmail.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, arjan@infradead.org, mingo@elte.hu,
       a.p.zijlstra@chello.nl, kyle@parisc-linux.org, schwidefsky@de.ibm.com
Subject: Re: [PATCH] lib: Taint kernel in common report_bug() WARN path.
Message-ID: <20080516145718.GD9666@phobos.i.cabal.ca>
References: <20080516052127.GB15431@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516052127.GB15431@linux-sh.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 02:21:27PM +0900, Paul Mundt wrote:
> Commit 95b570c9cef3b12356454c7112571b7e406b4b51 introduced a
> TAINT_WARN that was implemented for all architectures using the
> generic warn_on_slowpath(), which excluded any architecture that
> set HAVE_ARCH_WARN_ON.
> 
> As all of the architectures that implement their own WARN_ON()
> all go through the report_bug() path (specifically handling
> BUG_TRAP_TYPE_WARN), taint the kernel there as well for consistency.
> 
> Tested on avr32 and sh. Also relevant for s390, parisc, and powerpc.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 

obviously fine by me.

Acked-by: Kyle McMartin <kyle@mcmartin.ca>
