Return-Path: <linux-kernel-owner+w=401wt.eu-S935165AbXGRAIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935165AbXGRAIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933908AbXGRAIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:08:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58203 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933630AbXGRAId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:08:33 -0400
Date: Tue, 17 Jul 2007 17:07:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ben Dooks <ben@fluff.org>
cc: David Miller <davem@davemloft.net>, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, avi@qumranet.com
Subject: Re: [PATCH] smp_call_function_single() should be a macro on UP
In-Reply-To: <20070717235417.GA18459@fluff.org.uk>
Message-ID: <alpine.LFD.0.999.0707171707030.27353@woody.linux-foundation.org>
References: <20070717212946.GP21668@ftp.linux.org.uk>
 <20070717.144042.41636155.davem@davemloft.net>
 <20070717235417.GA18459@fluff.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Ben Dooks wrote:
> 
> This has broken _all_ ARM builds, due to using WARN_ON()
> in this header.

I think Al's patch already fixes that, since now it's back to being a 
macro, and thus the whole WARN_ON() is only visible where the macro is 
_used_, not in the header itself.

		Linus
