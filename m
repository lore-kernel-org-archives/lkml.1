Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYHZUD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYHZUD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbYHZUDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:03:47 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:54338 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbYHZUDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=GoRsoZa3zWDn5Ms7FvfF3e19qsLv1z1PxC6veE6tGH0SsrYZCb/76vEo4lar6tqpKJ
         5OwULZE9IxXe/xBcm5rBiB2JjkkZ5pmtNUTJqvqjJvGqdV8BuRT1o8ALHLNXY5BlYp1w
         eOadxsQamVxinYdHeI3v5ub/EVdSqxMqGfOds=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] 2.6.27-rc4-git3: make section names compatible with -ffunction-sections -fdata-sections
Date: Tue, 26 Aug 2008 22:05:32 +0200
User-Agent: KMail/1.8.2
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, x86@kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
References: <200808250118.08406.vda.linux@googlemail.com> <1219775585.3797.2.camel@dhcp32.mvista.com>
In-Reply-To: <1219775585.3797.2.camel@dhcp32.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808262205.32222.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008 20:33, Daniel Walker wrote:
> On Mon, 2008-08-25 at 01:18 +0200, Denys Vlasenko wrote:
> > Hi Andrew,
> > 
> > You asked me to maintain it and resubmit when
> > merge frenzy is over.
> > 
> > Here is the update against current Linus tree
> > (which is 2.6.27-rc4-git3), rolled up into one patch.
> 
> 
> Do you have the patches that actually use
> -ffunction-sections,-fdata-sections updated someplace?

I had, but it's a PITA to maintain and rediff them.
My current plan is to get this merged first,
and then introduce another change which actually
puts -ffunction-sections,-fdata-sections to use.
It will be much easier to review this way.
--
vda
