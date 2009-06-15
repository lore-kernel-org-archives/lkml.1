Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbZFOLq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbZFOLq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZFOLqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:46:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZFOLqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:46:48 -0400
Date: Mon, 15 Jun 2009 07:46:49 -0400
From: Christoph Hellwig <hch@infradead.org>
To: liqin.chen@sunplusct.com
Cc: Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] new files for score architecture
Message-ID: <20090615114649.GA20531@infradead.org>
References: <20090615112628.GA26150@infradead.org> <OF28F09400.68D4B737-ON482575D6.003FA1F3-482575D6.00403088@sunplusct.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF28F09400.68D4B737-ON482575D6.003FA1F3-482575D6.00403088@sunplusct.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 07:36:33PM +0800, liqin.chen@sunplusct.com wrote:
> Thanks your comment, I had removed unused code from ptrace.

Note that it's not simply unused code.  There have been quite a few
changes to the ptrace interface over the last year, including moving
more code into generic helpers.  Take a look at those architectures
defining HAVE_ARCH_TRACEHOOK in their Kconfig for a guide.  Fortunately
it should make the remaining architecture code a lot simpler.

Also http://sourceware.org/systemtap/wiki/utrace/arch/HowTo might
be pretty helpful.
