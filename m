Return-Path: <linux-kernel-owner+w=401wt.eu-S1761518AbXEXB7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518AbXEXB7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbXEXB7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:59:07 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:34040 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbXEXB7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:59:07 -0400
Subject: Re: [PATCH 5/6] SUNHME: Workaround ancient hang on U1's
From: Ben Collins <ben.collins@ubuntu.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070523.171723.68041701.davem@davemloft.net>
References: <98cd38b5.git.bcollins@ubuntu.com>
	 <91fcd7d6a83321c37f6769164b1b41ce78a07bfa.1179964369.git.bcollins@ubuntu.com>
	 <20070523.171723.68041701.davem@davemloft.net>
Content-Type: text/plain
Organization: Canonical
Date: Wed, 23 May 2007 21:59:18 -0400
Message-Id: <1179971958.12570.161.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 17:17 -0700, David Miller wrote:
> From: Ben Collins <bcollins@ubuntu.com>
> Date: Wed, 23 May 2007 18:30:46 -0400
> 
> > This work around has been in use by almost any distribution trying to
> > support sparc64 since at least 2002. Without it, sunhme hangs fairly
> > quickly on UltraSPARC 1's.
> > 
> > Dave, I know it's not in the kernel because it isn't a "fix", but given
> > that we haven't seen a fix in more than 5 years, can we get this out of my
> > tree please? :)
> 
> It isn't needed any more, the hang no longer occurs.
> 
> Nobody should be applying that patch, my guess is that it was
> a GCC bug that has been fixed over time that reordered the
> writes to RX/TX descriptors which hung the chip.

Ah, thanks. I'll revert it out. Seemed like every time I yanked it out
of the our tree (Debian/Ubuntu) some one would complain, and I had to
put it back in.

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

