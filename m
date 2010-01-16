Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab0APMde (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 07:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572Ab0APMdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 07:33:33 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:51582 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0APMdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 07:33:32 -0500
Date: Sat, 16 Jan 2010 12:33:13 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yuhong Bao <yuhongbao_386@hotmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
Message-ID: <20100116123313.GA20059@sucs.org>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl> <4B511B12.6010208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B511B12.6010208@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 05:49:06PM -0800, H. Peter Anvin wrote:
> On 12/30/2009 05:29 PM, Yuhong Bao wrote:
> > 
> > Given that Linus was once talking about the performance penalties of
> > PAE and HIGHMEM64G, perhaps you'd find these benchmarks done by
> > Phoronix of interest:
> > http://www.phoronix.com/scan.php?page=article&item=ubuntu_32_pae
> > 
> 
> The big difference isn't between HIGHMEM4G (no PAE) and HIGHMEM64G
> (PAE), it's between HIGHMEM and !HIGHMEM.  That cutoff is ~892 MB for a
> stock 32-bit kernel.

Thanks for the clarification - I had been wondering about why those
settings had been benchmarked against each other...

I took a mild interest because I have an EeePC 900 with 1G of RAM. The
machine can do PAE but my understanding is that this would lead to a
performance drop (I currently have VMSPLIT_3G so I can use all 1G of
memory) so I run it without HIGHMEM.

-- 
Sitsofe | http://sucs.org/~sits/
