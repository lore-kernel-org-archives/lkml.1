Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbXCYQEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbXCYQEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXCYQEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:04:09 -0400
Received: from waste.org ([66.93.16.53]:35206 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbXCYQEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:04:07 -0400
Date: Sun, 25 Mar 2007 10:51:27 -0500
From: Matt Mackall <mpm@selenic.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [patch 2/3] only allow nonlinear vmas for ram backed filesystems
Message-ID: <20070325155127.GR10459@waste.org>
References: <E1HVEOB-0006fX-00@dorka.pomaz.szeredi.hu> <E1HVEQJ-0006gF-00@dorka.pomaz.szeredi.hu> <1174824752.5149.28.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174824752.5149.28.camel@lappy>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 02:12:32PM +0200, Peter Zijlstra wrote:
> On Sat, 2007-03-24 at 23:09 +0100, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Dirty page accounting/limiting doesn't work for nonlinear mappings, so
> > for non-ram backed filesystems emulate with linear mappings.  This
> > retains ABI compatibility with previous kernels at minimal code cost.
> > 
> > All known users of nonlinear mappings actually use tmpfs, so this
> > shouldn't have any negative effect.

They do? I thought the whole point of nonlinear mappings was for
mapping files bigger than the address space (eg. databases). Is Oracle
instead using this to map >3G files on a tmpfs??

-- 
Mathematics is the supreme nostalgia of our time.
