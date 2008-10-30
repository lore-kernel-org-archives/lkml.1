Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbYJ3IDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbYJ3IDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 04:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYJ3IDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 04:03:14 -0400
Received: from verein.lst.de ([213.95.11.210]:35424 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbYJ3IDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 04:03:11 -0400
Date: Thu, 30 Oct 2008 09:02:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: Stale NFS File Handle but !NFS
Message-ID: <20081030080232.GA26490@lst.de>
References: <f7848160810231458tea58cf7x362ad03743b564ed@mail.gmail.com> <20081029175643.ad0f1dca.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029175643.ad0f1dca.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 05:56:43PM -0700, Andrew Morton wrote:
> Is this still happening?
> 
> If so, I'd be looking at that new `return ERR_PTR(-ESTALE)' in
> d_obtain_alias().

d_obtain is only used in the nfs export code, some special case in the
nfs client code and the xfs open by handle code.
