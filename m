Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZBIBwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZBIBwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbZBIBvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:51:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753885AbZBIBvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:51:52 -0500
Date: Sun, 8 Feb 2009 17:50:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: dilinger@queued.net, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com
Subject: Re: [PATCH 10/15] sunxvr500: fix cmap memory leaks
Message-Id: <20090208175024.6e58671f.akpm@linux-foundation.org>
In-Reply-To: <20090208.165925.240846008.davem@davemloft.net>
References: <20090207121540.0e618d0f@ephemeral>
	<20090208.165925.240846008.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Feb 2009 16:59:25 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: Andres Salomon <dilinger@queued.net>
> Date: Sat, 7 Feb 2009 12:15:40 -0500
> 
> [ Fixed typo in adaplas's email address ]
> 
> >  - fix cmap leak in removal path
> >  - fix cmap leak when register_framebuffer fails
> > 
> > Signed-off-by: Andres Salomon <dilinger@debian.org>
> 
> I assume the fbdev folks will pick this up or should I take
> it in my sparc tree?

(fbdev folks == me) at present.  I'll crunch on these 15 patches
tomorrow.  If you want to queue it in in a sparc tree so that it gets
more-than-zero runtine testing then go for it.

