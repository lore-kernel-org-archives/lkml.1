Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZEVVAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZEVVAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbZEVU7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:59:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44923 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010AbZEVU7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:59:53 -0400
Message-ID: <4A171224.5090500@zytor.com>
Date: Fri, 22 May 2009 13:59:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86,APIC: Detect lapic_is_integrated() once - use on
 and on.
References: <b9df5fa10905220631y7b1a094dn9a6e13de1b9c43af@mail.gmail.com> <20090522200239.GD5354@lenovo> <4A170713.402@zytor.com> <20090522202154.GG5354@lenovo> <4A1709D9.4070300@zytor.com> <20090522203529.GI5354@lenovo>
In-Reply-To: <20090522203529.GI5354@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [H. Peter Anvin - Fri, May 22, 2009 at 01:23:53PM -0700]
> | Cyrill Gorcunov wrote:
> | > 
> | > It was about a half year ago (need googling to be precise :)
> | > but I was reported about Xeon processor which identify itself
> | > as having "external" apic. So I hardly believe if real external
> | > device with ICC bus were used.
> | >  
> | 
> | Details, please.  It might even be a bug in the test.
> | 
> | 	-hpa
> | 
> 
> Here is it
> 
> 	http://lkml.org/lkml/2008/10/17/147
> 	http://lkml.org/lkml/2008/10/20/144
> 
> and commit db96b0a in mainline
> 

There isn't much detail about the system... no cpuinfo nor any DMI
information.  This makes me believe that the problem was misdiagnosed,
as you yourself speculate at the end of the thread.

It's also possible that this particular Xeon might have a different kind
of APIC, but if so, that's not the same thing as this being a
non-integrated APIC.  Unfortunately Xeon just means "Intel server chip"
and without a CPUID it's impossible to know what CPU that was.

	-hpa
