Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbYGTGjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbYGTGjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 02:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYGTGi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 02:38:59 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:34936 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYGTGi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 02:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p3QMeUnM2Ce1SKmnDboXqK8Ih7QEFr7wf9cefoclPsFExUpBb1DCnD3YW5dfzaX1Kp
         Tc5SuFLxmdaxjhg1mK45zC011gaaw/UALrOycFESymjUXIvmArjvhsbrYl0FPcPVXUqu
         YVvN3M7KXIQJp7J9w/jusGAqgSiGn7HJizq2c=
Date: Sun, 20 Jul 2008 10:38:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: warn on apic error
Message-ID: <20080720063855.GA8513@asus>
References: <20080718172821.GA4149@localhost.localdomain> <20080718174413.GD6897@asus> <19f34abd0807181045k239c81e8i1520291922909e93@mail.gmail.com> <20080718174931.GE6897@asus> <Pine.LNX.4.55.0807182005330.12125@cliff.in.clinika.pl> <20080719125907.GA30979@asus> <Pine.LNX.4.55.0807192352030.19091@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807192352030.19091@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sun, Jul 20, 2008 at 12:08:23AM +0100]
| On Sat, 19 Jul 2008, Cyrill Gorcunov wrote:
| 
| > [Maciej W. Rozycki - Fri, Jul 18, 2008 at 08:09:20PM +0100]
| > | On Fri, 18 Jul 2008, Cyrill Gorcunov wrote:
| > | 
| > | > iirc, they all were there (though some error codes are specific for
| > | > particular processor classes like P4, pentium and other - don't remeber
| > | > you could check intel dev manual for this).
| > | 
| > |  This is an error in some newer Intel documents -- the set of supported
| > | bits is the same for all APICs implementing the ESR register and the error
| > | interrupt (the 82489DX is the one to provide neither).
| > | 
| > |   Maciej
| > |
| > 
| > But Maciej, Intel doesn't claim about absence of bit but
| > rather about their 'reserved' state so checking the reserved
| > bit could be false alarm if it was being set by some reason.
| 
|  As I say -- all later manuals have an error here (not the first and
| presumably not the last one), where they state the invalid register error
| has been only implemented since the P6.  This is not true -- go find the
| Pentium manual or experiment with actual hardware to see otherwise.  No
| new bits have been added since the introduction of the ESR, so there is no
| issue with bits to mask out on older silicon.
| 
|  Obviously the checksum and accept error bits are valid for APICs using
| the dedicated inter-APIC bus only as for the FSB they are irrelevant.  
| They have to be hardwired to zero for backward compatibility though.
| 
|   Maciej
| 

Thanks a lot, Maciej!

		- Cyrill -
