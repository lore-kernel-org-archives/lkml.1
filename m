Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbYHYLhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbYHYLhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 07:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYHYLhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 07:37:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:52129 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYHYLhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 07:37:43 -0400
Subject: Re: [PATCH] [MTD] mtdchar.c: Fix regression in MEMGETREGIONINFO
	ioctl()
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zev Weiss <zevweiss@gmail.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <20080823222707.2fb972b5.akpm@linux-foundation.org>
References: <48ABCC0B.40607@gmail.com>
	 <20080822153451.bb79bd1f.akpm@linux-foundation.org>
	 <48AFC5ED.50005@gmail.com>
	 <20080823222707.2fb972b5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 12:37:37 +0100
Message-Id: <1219664257.9583.36.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-23 at 22:27 -0700, Andrew Morton wrote:
> 
> > On the other hand, if I'm missing something completely, please let me know,
> > and perhaps I can prepare a more suitable fix.
> 
> "good enough" is never good enough ;)
> 
> What is the ideal implementation?  Let's implement that.

It involves ditching the ioctls altogether (well, not adding anything
_more_ to them, at least) and doing it through sysfs.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



