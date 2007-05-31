Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbXEaWde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbXEaWde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXEaWd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:33:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58983 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbXEaWdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:33:25 -0400
Date: Fri, 1 Jun 2007 00:33:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
Message-ID: <20070531223322.GC7217@one.firstfloor.org>
References: <20070530140025.917261793@polymtl.ca> <20070530140229.811672406@polymtl.ca> <p736469dsdb.fsf@bingen.suse.de> <20070531220742.GG904@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531220742.GG904@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I see your point, but there is a level of control on the branch I would
> lack by doing so: the ability to put the call in either the if or else
> branch. It is an optimization on i386.

What does it optimize exactly?

> Also, I live in the expectation that, someday, the gcc guys will be nice
> enough to add some kind of support for a nop-based jump that would
> require code patching to put a jump instead. If it ever happens, my
> macro could evolve into this for newer compiler versions, which I could
> not do with the if() statement you are proposing.

If that ever happens we couldn't use it anyways because Linux still
has to support old compilers for a long time. And when those are dropped the
code could be updated.

-Andi
