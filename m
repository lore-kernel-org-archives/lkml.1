Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbXHBNaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbXHBNaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbXHBNa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:30:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60104 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbXHBNa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:30:29 -0400
Message-ID: <46B1DABA.3090800@zytor.com>
Date: Thu, 02 Aug 2007 09:23:06 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: Daniel Drake <dsd@gentoo.org>, Zwane Mwaikambo <zwane@infradead.org>,
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

>  
> How about this patch?
> 
> Tony
> ---
> 
> Subject: video setup: Fix VBE DDC reading
> 
> Add memory operand constraint and write-only modifier to the inline
> assembly to effect the writing of the EDID block to boot_params.edid_info.
> 
> Signed-off-by: Antonino Daplas <adaplas@gmail.com>

OK, now I feel dumb.  You're absolutely right; without that constraint, 
the entire EDID function after the memset is eliminated by gcc as being 
dead code.

Will queue the patch.

	-hpa

