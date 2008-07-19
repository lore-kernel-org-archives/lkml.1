Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYGSM7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYGSM7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYGSM7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:59:09 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:60164 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYGSM7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mUz8KzL8d7sWjMnzGGTAwI55w7IyXX4S/w/wVZiANcZexLLh9zA/uOYxEmlia7CFyi
         EBkKKZM0J79bJPQH9F3lEZ8hkHBIQVG6AJYWlaWrkJPVtlHHrbytk+dtvFckewsoSVw2
         hQqgFL2vVz8fIbzTsbWrB2uWdfc7GGwSXjET8=
Date: Sat, 19 Jul 2008 16:59:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: warn on apic error
Message-ID: <20080719125907.GA30979@asus>
References: <20080718172821.GA4149@localhost.localdomain> <20080718174413.GD6897@asus> <19f34abd0807181045k239c81e8i1520291922909e93@mail.gmail.com> <20080718174931.GE6897@asus> <Pine.LNX.4.55.0807182005330.12125@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807182005330.12125@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Fri, Jul 18, 2008 at 08:09:20PM +0100]
| On Fri, 18 Jul 2008, Cyrill Gorcunov wrote:
| 
| > iirc, they all were there (though some error codes are specific for
| > particular processor classes like P4, pentium and other - don't remeber
| > you could check intel dev manual for this).
| 
|  This is an error in some newer Intel documents -- the set of supported
| bits is the same for all APICs implementing the ESR register and the error
| interrupt (the 82489DX is the one to provide neither).
| 
|   Maciej
|

But Maciej, Intel doesn't claim about absence of bit but
rather about their 'reserved' state so checking the reserved
bit could be false alarm if it was being set by some reason.

		- Cyrill -
