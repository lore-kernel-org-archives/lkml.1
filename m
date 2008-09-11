Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYIKC42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYIKC42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 22:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbYIKC4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 22:56:20 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:41693 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbYIKC4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:56:19 -0400
Date: Wed, 10 Sep 2008 22:55:18 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, davem@davemloft.net, jeffm@suse.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Message-ID: <20080911025518.GA23031@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>, davem@davemloft.net,
	jeffm@suse.com, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org
References: <48C68507.6000609@suse.com> <1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net> <1221088512.13621.58.camel@macbook.infradead.org> <20080910162404.a3208b8f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910162404.a3208b8f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 04:24:04PM -0700, Andrew Morton wrote:
> 
> A suitable approach might be to copy the files to both /lib/firmware
> and to /lib/firmware/$KERNELRELEASE, and to stop copying the files to
> /lib/firmware in, oh, 2018 or so..

Or make it be a KCONFIG build option, so that people who are building
kernels using the distribution-specific kernel packaging tool can pass
in whatever is right for their distribution....

							- Ted
