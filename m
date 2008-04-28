Return-Path: <linux-kernel-owner+w=401wt.eu-S1765923AbYD1G3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765923AbYD1G3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbYD1G3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:29:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50756 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbYD1G3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:29:37 -0400
Date: Mon, 28 Apr 2008 02:29:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
Message-ID: <20080428062935.GA13876@infradead.org>
References: <20080427.170139.242528272.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427.170139.242528272.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 05:01:39PM -0700, David Miller wrote:
> 
> Several fixes and cleanups:
> 
> 1) Remove SunOS signal frame support, that Linux used for like
>    a month some 12 years ago :-)  I added an assertion that checks
>    to make sure 32-bit processes request the newer style signal
>    frames, which I doubt will ever trigger since Jakub Jelinek
>    and myself are probably the only two people on the planet who
>    ever had such Linux binaries on their system :-)

Is a WARN_ON the right check for user-triggerable behaviour?  I think
a normal rate-limited printk with a descriptive text would be better.

>    Getting rid of the EBUS layer is much hardware, and will require

					  harder? :)

