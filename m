Return-Path: <linux-kernel-owner+w=401wt.eu-S936731AbXGRXux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936731AbXGRXux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbXGRXum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:50:42 -0400
Received: from ns.suse.de ([195.135.220.2]:59582 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbXGRXul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:50:41 -0400
Date: Thu, 19 Jul 2007 01:50:35 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070718235035.GB29728@v2.random>
References: <20070706222651.GG5777@v2.random> <1183764801.10287.233.camel@localhost> <20070706235228.GL5777@v2.random> <20070717174737.GM6909@holomorphy.com> <20070717193308.GD25301@v2.random> <20070718133222.GM11781@holomorphy.com> <469E410C.50302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E410C.50302@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 06:34:20PM +0200, Rene Herman wrote:
> It says that highmem is not an issue due to no such thing as highmem even 
> existing on the machines with support for larger hard pagesizes, but this 
> wouldn't hold for soft pages. Sort of went "damn" in an x86 context upon 
> reading that.

Correct, but I'm not really sure if it worth worrying about x86
missing this, furthermore it would still be possible to enable it on
the very x86 low end (with regular 4k page size) that may worry to use
up to the last byte of ram as cache for tiny files. To me using
kmalloc for this looks quite ideal.

Thanks.
