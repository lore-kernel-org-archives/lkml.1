Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbXIFKAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbXIFKAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXIFKAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:00:00 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58304 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbXIFJ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 05:59:59 -0400
Subject: Re: [2/2] 2.6.23-rc5: known regressions with patches
From: David Woodhouse <dwmw2@infradead.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <46DBDDC6.9030602@googlemail.com>
References: <46DBDCF4.6040805@googlemail.com>
	 <46DBDDC6.9030602@googlemail.com>
Content-Type: text/plain
Date: Thu, 06 Sep 2007 10:59:59 +0100
Message-Id: <1189072799.2745.68.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-03 at 12:11 +0200, Michal Piotrowski wrote:
> MTD
> 
> Subject         : error: implicit declaration of function 'cfi_interleave'
> References      : http://lkml.org/lkml/2007/8/6/272
> Last known good : ?
> Submitter       : Ingo Molnar <mingo@elte.hu>
> Caused-By       : ?
> Handled-By      : David Woodhouse <dwmw2@infradead.org>
> Patch           : http://lkml.org/lkml/2007/8/9/586
> Status          : patch available 

This isn't really a regression -- it's been like this for years. It's a
non-functional configuration which doesn't really make sense, and would
only crop up with randconfig (or crack).

Linus was offered the patch a few weeks ago, but didn't take it -- it's
not really a priority for 2.6.23. It's in my git tree and will be pushed
when the 2.6.24 merge window opens.

http://git.infradead.org/?p=mtd-2.6.git;a=commitdiff;h=241651d04d672fb685b2874707016cbbf95931e5

-- 
dwmw2

