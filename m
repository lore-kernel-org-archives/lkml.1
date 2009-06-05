Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZFEULv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZFEULv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 16:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZFEULo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 16:11:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57540 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZFEULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 16:11:43 -0400
Date: Fri, 5 Jun 2009 21:10:01 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/6] headers_check fix: arm, hwcap.h
Message-ID: <20090605201001.GA17085@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam> <1244118476.5172.29.camel@ht.satnam> <20090604125306.GC24491@flint.arm.linux.org.uk> <20090604201649.GC13892@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604201649.GC13892@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 10:16:49PM +0200, Sam Ravnborg wrote:
> On Thu, Jun 04, 2009 at 01:53:07PM +0100, Russell King wrote:
> > On Thu, Jun 04, 2009 at 05:57:56PM +0530, Jaswinder Singh Rajput wrote:
> > > fix the following 'make headers_check' warning:
> > 
> > I think headers_check needs fixing - there's nothing wrong with the
> > code as it presently stands except the tools obviously can't properly
> > parse C preprocessor statements.
> 
> You are correct that headers_ceck is limited here and this patch
> take some valid code and refactor it to make it headers_check compatible.

If it is just a matter of unifdef not doing the right thing, then that's
a bug in unifdef - looking at the code, it _should_ handle the case as
it's currently in the tree.

I'll spend a bit looking at this issue before applying this patch - if
the fix turns out to be trivial then we all win by not requiring people
to write stuff in unexpected (to the tools, but standard C) ways.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
