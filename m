Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbXGJSJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbXGJSJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbXGJSJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:09:32 -0400
Received: from smtp121.iad.emailsrvr.com ([207.97.245.121]:42740 "EHLO
	smtp121.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbXGJSJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:09:32 -0400
Message-ID: <4693CAFF.4000609@gentoo.org>
Date: Tue, 10 Jul 2007 14:07:59 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       zwane@infradead.org, Andi Kleen <ak@suse.de>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com>	<4686D85B.6090803@gentoo.org>	<20070630154230.4ad373fa.akpm@linux-foundation.org>	<4690E65B.5050607@gentoo.org> <20070708111404.1486e73c.akpm@linux-foundation.org> <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org> <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org> <4693C0A1.8010901@zytor.com>
In-Reply-To: <4693C0A1.8010901@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> You're complaining that we didn't query EDID when you *explicitly* asked
> us not to.  This is not a bug!

I see -- I didn't realise CONFIG_FIRMWARE_EDID was one of options that 
you shouldn't disable unless you have a good reason. Thanks for the 
explanation.

So, 2.6.22-rc6-mm1 should work fine with CONFIG_FIRMWARE_EDID=y, or are 
further patches needed?

Thanks!
Daniel
