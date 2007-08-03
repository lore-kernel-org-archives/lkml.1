Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbXHCChe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbXHCChe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 22:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbXHCChZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 22:37:25 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:60087 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbXHCChY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 22:37:24 -0400
Message-ID: <46B293E0.2080008@gentoo.org>
Date: Thu, 02 Aug 2007 22:33:04 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Zwane Mwaikambo <zwane@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com> <4686D85B.6090803@gentoo.org>	 <20070630154230.4ad373fa.akpm@linux-foundation.org>	 <4690E65B.5050607@gentoo.org>	 <20070708111404.1486e73c.akpm@linux-foundation.org>	 <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org>	 <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org>	 <4693C0A1.8010901@zytor.com> <4693CAFF.4000609@gentoo.org>	 <4693CCC6.7050400@zytor.com> <46AFCCBB.70307@gentoo.org>	 <Pine.LNX.4.64.0707311719540.5207@montezuma.windriver.com>	 <46AFDF3A.6080300@gentoo.org>  <1185933291.4688.11.camel@daplas>	 <1186024158.4629.1.camel@daplas> <46B1547F.3090403@zytor.com> <46B1AF0E.40703@gmail.com>
In-Reply-To: <46B1AF0E.40703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas wrote:
> How about this patch?
> 
> Tony
> ---
> 
> Subject: video setup: Fix VBE DDC reading
> 
> Add memory operand constraint and write-only modifier to the inline
> assembly to effect the writing of the EDID block to boot_params.edid_info.


Thanks, this patch works in that Linux now reports the correct resolution.

However, the TV output is now scrambled...
I suspect this might be a result of adding CONFIG_FRAMEBUFFER_CONSOLE in 
the most recent tests. I've asked the user to test without that option 
but with the patch:

https://bugs.gentoo.org/show_bug.cgi?id=181067#c27

Thanks!
Daniel
