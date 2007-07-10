Return-Path: <linux-kernel-owner+w=401wt.eu-S1763707AbXGJSW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763707AbXGJSW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbXGJSWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:22:49 -0400
Received: from terminus.zytor.com ([192.83.249.54]:55497 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbXGJSWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:22:48 -0400
Message-ID: <4693CCC6.7050400@zytor.com>
Date: Tue, 10 Jul 2007 11:15:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       zwane@infradead.org, Andi Kleen <ak@suse.de>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com>	<4686D85B.6090803@gentoo.org>	<20070630154230.4ad373fa.akpm@linux-foundation.org>	<4690E65B.5050607@gentoo.org> <20070708111404.1486e73c.akpm@linux-foundation.org> <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org> <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org> <4693C0A1.8010901@zytor.com> <4693CAFF.4000609@gentoo.org>
In-Reply-To: <4693CAFF.4000609@gentoo.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> H. Peter Anvin wrote:
>> You're complaining that we didn't query EDID when you *explicitly* asked
>> us not to.  This is not a bug!
> 
> I see -- I didn't realise CONFIG_FIRMWARE_EDID was one of options that
> you shouldn't disable unless you have a good reason. Thanks for the
> explanation.
> 
> So, 2.6.22-rc6-mm1 should work fine with CONFIG_FIRMWARE_EDID=y, or are
> further patches needed?
> 

It should, yes.

	-hpa
