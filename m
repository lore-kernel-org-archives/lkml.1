Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbYCCVbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbYCCVbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYCCVbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:31:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:53941 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYCCVa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:30:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=wPwrULt0/1Fksms1x+pxgY0gfbBe7K+uTkBZF7NrQwsRvB1QdLKBxeHUYcH2BiSl3fcSqy7iJ4UIgxQnWSJGMhh4f/fgpc4Pv5+ZC/LicAFjFu8eqB5T+8CwrAEYbtd4BEgBuVtsqpPL7u8Ncm1WwjLDp1YLg75WItgli00V9kU=
Message-ID: <84144f020803031330i2c0ea1f6kc5b02c8b26145797@mail.gmail.com>
Date: Mon, 3 Mar 2008 23:30:56 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
Cc: "Nick Piggin" <npiggin@suse.de>, netdev@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, "David Miller" <davem@davemloft.net>,
       "Eric Dumazet" <dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080303093449.GA15091@wotan.suse.de>
	 <Pine.LNX.4.64.0803031107130.6917@schroedinger.engr.sgi.com>
	 <20080303200613.GC8974@wotan.suse.de>
	 <Pine.LNX.4.64.0803031209570.16049@schroedinger.engr.sgi.com>
	 <20080303201701.GF8974@wotan.suse.de>
	 <Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: a1a1a051a721e480
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 3 Mar 2008, Nick Piggin wrote:
> > > HWCACHE_ALIGN means that you want the object to be aligned at
> > > cacheline boundaries for optimization. Why does crossing cacheline
> > > boundaries matter in this case?
> >
> > No, HWCACHE_ALIGN means that you want the object not to cross cacheline
> > boundaries for at least cache_line_size() bytes. You invented new

On Mon, Mar 3, 2008 at 11:16 PM, Christoph Lameter <clameter@sgi.com> wrote:
>  Interesting new definition....

Well, not my definition either but SLAB has guaranteed that for small
objects in the past, so I think Nick has a point here. However, with
all this back and forth, I've lost track why this matters. I suppose
it causes regression on some workload?

                                Pekka
