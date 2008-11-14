Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbYKNR12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbYKNR12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYKNR1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:27:20 -0500
Received: from kroah.org ([198.145.64.141]:58702 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750936AbYKNR1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:27:20 -0500
Date: Fri, 14 Nov 2008 08:58:07 -0800
From: Greg KH <greg@kroah.com>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, sandeen@redhat.com,
       akpm@linux-foundation.org, dustin.kirkland@gmail.com,
       pjssilva@ime.usp.br
Subject: Re: [stable] [PATCH] eCryptfs: Allocate up to two scatterlists for
	crypto ops on keys
Message-ID: <20081114165807.GA20656@kroah.com>
References: <20081114164053.GC6624@halcrowt61p.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114164053.GC6624@halcrowt61p.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 10:40:53AM -0600, Michael Halcrow wrote:
> I have received some reports of out-of-memory errors on some older AMD
> architectures. These errors are what I would expect to see if
> crypt_stat->key were split between two separate pages. eCryptfs should
> not assume that any of the memory sent through virt_to_scatterlist()
> is all contained in a single page, and so this patch allocates two
> scatterlist structs instead of one when processing keys. I have
> received confirmation from one person affected by this bug that this
> patch resolves the issue for him, and so I am submitting it for
> inclusion in a future stable release.

Is this already in Linus's tree?  If so, do you have the git commit id
for it?

If not, we can't take it into a stable kernel until that happens.  To
get patches automatically added to the stable tree, when they get added
to Linus's tree, just add:
	Cc: stable <stable@kernel.org>
to the signed-off-by: area of the patch and it will get automatically
routed to us.

thanks,

greg k-h
