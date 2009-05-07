Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbZEGWQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbZEGWQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZEGWQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:16:39 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:56978 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763349AbZEGWQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:16:38 -0400
Date: Thu, 7 May 2009 15:16:28 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chris Snook <chris.snook@gmail.com>, akataria@vmware.com,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507221628.GI6377@localdomain>
References: <1241462661.412.8.camel@alok-dev1> <4A00ADDE.9000908@zytor.com> <1241560625.8665.17.camel@alok-dev1> <13a12eea0905070935o5abbeb49n8320d06c15b19b56@mail.gmail.com> <1241715373.32495.21.camel@alok-dev1> <13a12eea0905071329s79fb262tf89ed901a77726ae@mail.gmail.com> <20090507213403.3a75a6fb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507213403.3a75a6fb@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 09:34:03PM +0100, Alan Cox wrote:
>> >> Given your use case, what you really need to do is get Red Hat,
>> >> Novell, et al. on the phone and ask them to ship kernels with HZ=100,
>> >> because the distributions do their own thing anyway.
>
>As a side note Red Hat ships runtime configurable tick behavior in RHEL
>these days. HZ is fixed but the ticks can be bunched up. That was done as
>a quick fix to keep stuff portable but its a lot more sensible than
>randomly messing with the HZ value and its not much code either.
>

That's interesting!
Could you please point us to the patch if you can?

(As a HPC + virtualization shop, we set HZ to 100 all the time,
and a patch like the one you mention above sounds great)

Thanks,
Kiran

