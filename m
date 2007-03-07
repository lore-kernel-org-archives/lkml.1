Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbXCGPUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbXCGPUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXCGPUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:20:05 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:56588 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbXCGPUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:20:03 -0500
Date: Wed, 7 Mar 2007 10:10:40 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, mingo@elte.hu, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307151040.GA2440@ccure.user-mode-linux.org>
References: <20070307103842.GD5555@wotan.suse.de> <1173264462.6374.140.camel@twins> <20070307110035.GE5555@wotan.suse.de> <1173268086.6374.157.camel@twins> <20070307121730.GC18704@wotan.suse.de> <1173271286.6374.166.camel@twins> <20070307130851.GE18704@wotan.suse.de> <1173273562.6374.175.camel@twins> <20070307133649.GF18704@wotan.suse.de> <1173275532.6374.183.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173275532.6374.183.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 02:52:12PM +0100, Peter Zijlstra wrote:
> > Well I don't think UML uses nonlinear yet anyway, does it? Can they
> > make do with restricting nonlinear to mlocked vmas, I wonder? Probably
> > not.
> 
> I think it does, but lets ask, Jeff?

Nope, UML needs to be able to change permissions as well as locations.

Would be nice, though, there are apparently nice UML speedups with it.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
