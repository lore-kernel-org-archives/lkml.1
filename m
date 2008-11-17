Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbYKQUXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbYKQUXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYKQUXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:23:36 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:46054 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYKQUXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:23:35 -0500
Date: Mon, 17 Nov 2008 14:27:28 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, sandeen@redhat.com,
       dustin.kirkland@gmail.com, pjssilva@ime.usp.br
Subject: Re: [PATCH] eCryptfs: Allocate up to two scatterlists for crypto
	ops on keys
Message-ID: <20081117202728.GB8196@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20081114164053.GC6624@halcrowt61p.austin.ibm.com> <20081114165807.GA20656@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114165807.GA20656@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 08:58:07AM -0800, Greg KH wrote:
> On Fri, Nov 14, 2008 at 10:40:53AM -0600, Michael Halcrow wrote:
> > I have received some reports of out-of-memory errors on some older AMD
> > architectures. These errors are what I would expect to see if
> > crypt_stat->key were split between two separate pages. eCryptfs should
> > not assume that any of the memory sent through virt_to_scatterlist()
> > is all contained in a single page, and so this patch allocates two
> > scatterlist structs instead of one when processing keys. I have
> > received confirmation from one person affected by this bug that this
> > patch resolves the issue for him, and so I am submitting it for
> > inclusion in a future stable release.
> 
> Is this already in Linus's tree?

Nope. This patch needs to be merged to that point.
