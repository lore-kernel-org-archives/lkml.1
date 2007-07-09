Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbXGIBM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbXGIBM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 21:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbXGIBMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 21:12:20 -0400
Received: from smtp151.iad.emailsrvr.com ([207.97.245.151]:40994 "EHLO
	smtp151.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbXGIBMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 21:12:20 -0400
Message-ID: <46918B1C.9030604@gentoo.org>
Date: Sun, 08 Jul 2007 21:10:52 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       zwane@infradead.org, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com>	<4686D85B.6090803@gentoo.org>	<20070630154230.4ad373fa.akpm@linux-foundation.org>	<4690E65B.5050607@gentoo.org> <20070708111404.1486e73c.akpm@linux-foundation.org>
In-Reply-To: <20070708111404.1486e73c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>> Well drat.  I didn't merge the patch because it conflicts with
>>> git-newsetup, and Peter believes that git-newsetup already contains an
>>> equivalent fix.  Testing 2.6.22-rc6-mm1 would confirm that.  Please.
>> 2.6.22-rc6-mm1 has the same problem (it is not fixed there).
>>
> 
> Well damn, we've let this slide for too long.
> 
> Guys, 2.6.22 is days away.  Do we think that the below is safe to merge
> now?
> 
> Add Daniel, this does fix things for you, doesn't it?

I don't have the issue, I'm just proxying for a bug reporter on the 
Gentoo bugzilla. According to him, Jan's patch does solve the problem:

https://bugs.gentoo.org/show_bug.cgi?id=181067#c8

Thanks,
Daniel

