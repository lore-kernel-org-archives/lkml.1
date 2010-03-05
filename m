Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0CEQVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:21:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640Ab0CEQVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:21:42 -0500
Date: Fri, 5 Mar 2010 08:19:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Luca Barbieri <luca.barbieri@gmail.com>,
       Daniel Stone <daniel@fooishbar.org>, David Miller <davem@davemloft.net>,
       skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100305161311.656711e0@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1003050814410.3788@localhost.localdomain>
References: <20100305123834.0d9c6277@lxorguk.ukuu.org.uk> <20100305.063718.211238119.davem@davemloft.net> <20100305151754.GB2505@tempa> <20100305.072612.186421758.davem@davemloft.net> <20100305154009.GC2505@tempa> <ff13bc9a1003050756rca44e03uffbfa3090f96e0ac@mail.gmail.com>
 <20100305161311.656711e0@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Alan Cox wrote:
> 
> Yeah perhaps Fedora should have pushed an update that was smart enough to
> handle the Nouveau old/new ABI before the patch went upstream. Hindsight
> is an exact science.

Alan - it seems you're missing the whole point.

The thing I objected to, in the VERY BEGINNING in this thread, i the fact 
that the thing was done in such a way that it's basically impossible to 
support the old/new ABI at all! Let me quote that second email:

 "That commit seems to _on_purpose_ try to avoid at all cost being 
  compatible. It not only removes some old entry-points, it literally 
  re-numbers all the ioctl numbers as it does so, apparently entirely in 
  order to just make it difficult to have some libdrm that can handle both 
  versions."

So it's not a "before the patch went upstream" issue. The same issue 
exists _after_ the patch went upstream.

The way this was done, it's apparently basically impossible for the Fedora 
people to push out packaged that support both the old and the new kernel.

Alan, if this had been done in a way that allowed that whole old/new ABI 
that you mention to work, I wouldn't have been complaining so much!

In other words - I've not been complaining about updating the ABI. I've 
been complaining about doing it in such a way that it's near impossible to 
go back-and-forth, because the very thing you suggest was made way way 
harder than it should be.

		Linus
