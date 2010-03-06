Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab0CFRmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 12:42:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751532Ab0CFRmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 12:42:49 -0500
Date: Sat, 6 Mar 2010 09:40:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <1267889034.24025.4.camel@segulix>
Message-ID: <alpine.LFD.2.00.1003060937370.31447@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>  <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>  <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain> <1267889034.24025.4.camel@segulix>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Mar 2010, Sergio Monteiro Basto wrote:
> 
> You shouldn't expect, by now, upgrade drm kernel without update libdrm
> or at least recompile libdrm.

Why?

Why shouldn't I expect that? I already outlined exactly _how_ it could be 
done.

Why are people saying that technology has to suck?

> So when you saw a error message "driver nouveau 0.0.n+1 and have 0.0.n"
> is completely right. 

No. It's _not_ right. The code knows what is wrong. Considering it a fatal 
error is _stupid_ and bad technology, when it could have just fixed it.

> Is not a perfect world, but as talked on xorg mailing list, some time
> ago, we do not have resources to test it in all versions.
> Is better focus on just one combination.

This is not about "testing all versions". It's fine to have just one 
combination. But why the hell doesn't it _load_ that one combination 
instead of just dying?

IOW, there is a check for a version. It could - instead of dying - just 
dlopen() the right version instead. 

Why are people making excuses for bad programming and bad technology? 

			Linus
