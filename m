Return-Path: <linux-kernel-owner+w=401wt.eu-S1762972AbZEGWTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762972AbZEGWTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZEGWTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:19:44 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:56814 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbZEGWTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:19:44 -0400
Subject: Re: [PATCH] x86: Reduce the default HZ value
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chris Snook <chris.snook@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090507213403.3a75a6fb@lxorguk.ukuu.org.uk>
References: <1241462661.412.8.camel@alok-dev1>	<4A00ADDE.9000908@zytor.com>
	 <1241560625.8665.17.camel@alok-dev1>
	 <13a12eea0905070935o5abbeb49n8320d06c15b19b56@mail.gmail.com>
	 <1241715373.32495.21.camel@alok-dev1>
	 <13a12eea0905071329s79fb262tf89ed901a77726ae@mail.gmail.com>
	 <20090507213403.3a75a6fb@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 07 May 2009 15:19:44 -0700
Message-Id: <1241734784.32495.31.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-05-07 at 13:34 -0700, Alan Cox wrote:
> > >> Given your use case, what you really need to do is get Red Hat,
> > >> Novell, et al. on the phone and ask them to ship kernels with HZ=100,
> > >> because the distributions do their own thing anyway.
> 
> As a side note Red Hat ships runtime configurable tick behaviour in RHEL
> these days. HZ is fixed but the ticks can be bunched up. That was done as
> a quick fix to keep stuff portable but its a lot more sensible than
> randomly messing with the HZ value and its not much code either.
> 
Hi Alan, 

I guess you are talking about the tick_divider patch ? 
And that's still same as reducing the HZ value only that it can be done
dynamically (boot time), right ? 

Thanks,
Alok

