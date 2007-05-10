Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbXEJBXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbXEJBXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 21:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXEJBXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 21:23:09 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:32854 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXEJBXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 21:23:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: lguest re-review
References: <20070509025122.f3cb7247.akpm@linux-foundation.org>
	<1178756648.7286.182.camel@localhost.localdomain>
	<20070509175018.a4a685b8.akpm@linux-foundation.org>
Date: Wed, 09 May 2007 19:22:32 -0600
In-Reply-To: <20070509175018.a4a685b8.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 9 May 2007 17:50:18 -0700")
Message-ID: <m1wszhsc9z.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> I don't get it.  Does lguest no longer need this code, or will
> it be reintroduced with an lguest merge, or something else?

No longer needed.

For the short term lguest has a separate entry point.  For the long term
2.6.23 we will rev the boot protocol, so lguest and Xen can work with
a bzImage and use our standard set of kernel parameters.

Eric

