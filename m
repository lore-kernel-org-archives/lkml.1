Return-Path: <linux-kernel-owner+w=401wt.eu-S1762779AbXGFHTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762779AbXGFHTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXGFHTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:19:14 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35803 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXGFHTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:19:13 -0400
Subject: Re: [PATCH] Check charset in scripts/checkpatch.pl
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070706000807.8f9f83ca.akpm@linux-foundation.org>
References: <1183705264.2747.20.camel@shinybook.infradead.org>
	 <20070706000807.8f9f83ca.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 03:19:50 -0400
Message-Id: <1183706391.2747.27.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 00:08 -0700, Andrew Morton wrote:
> On Fri, 06 Jul 2007 03:01:03 -0400 David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > Reject all legacy 8-bit character sets and allow only ASCII or UTF-8 to
> > be added to files or used in patch descriptions.
> 
> What is the reasoning behind this?

The character set used by the kernel is UTF-8. So we should check for
people trying to add invalid stuff in other character sets. There's no
way for them to _label_ legacy character sets as such; it's not like
MIME email where we can use a different charset for every mail and
expect people to cope. We need to be consistent.

> > Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> > 
> > Signed-off-by: asd
> 
> Jekyll & Hyde?

Oops. I prepended that to the output of 'git-diff' just to make
checkpatch happy. And then forgot about it when I inserted the text file
into my mailer.

-- 
dwmw2

