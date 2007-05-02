Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbXEBFlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbXEBFlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbXEBFk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:40:56 -0400
Received: from ozlabs.org ([203.10.76.45]:59625 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992765AbXEBFkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:40:17 -0400
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 15:40:03 +1000
Message-Id: <1178084403.28659.222.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 21:28 -0700, David Rientjes wrote:
> For all supported versions of gcc (major version 3 and above), functions
> and variables may be declared with __attribute__((unused)) to suppress
> warnings if they are declared but unused.

Adding this macro doesn't give us anything that simply saying
"__attribute__((unused))" doesn't give.  But it does add a layer of
kernel-specific indirection.

If we're going to get kernel-specific, I'd prefer to see:

__needed: suppress warning and don't discard,
__unneeded: suppress warning and might discard.

For me this fits better with how I think.

Rusty.


