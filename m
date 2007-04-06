Return-Path: <linux-kernel-owner+w=401wt.eu-S1767451AbXDFAsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767451AbXDFAsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767464AbXDFAsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:48:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45452 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767451AbXDFAsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:48:42 -0400
Date: Fri, 6 Apr 2007 02:48:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Define EFLAGS_IF
Message-ID: <20070406004839.GA27668@one.firstfloor.org>
References: <1174533374.2713.104.camel@localhost.localdomain> <46159256.1040705@zytor.com> <461592AA.4060103@goop.org> <46159480.20108@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46159480.20108@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 05:29:52PM -0700, H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
> >
> >That patch got dropped, and replaced by one which pulled all the flags
> >definitions out of <asm/processor.h>
> >
> 
> Saw that a little too late :)
> 
> In general, it would be nice if the various CPU constants were all 
> defined in one place, so I'd rather suggest protecting the appropriate 
> parts of asm/processor.h with #ifndef __ASSEMBLY__.

No processor.h is such a hodgepodge of unrelated stuff that any
splitting up is a good thing.

-Andi
