Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbXD0R06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbXD0R06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbXD0R06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:26:58 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47110 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbXD0R05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:26:57 -0400
Date: Fri, 27 Apr 2007 19:27:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [patch] uml: fix cmpxchg warnings in -mm
Message-ID: <20070427172748.GC1046@uranus.ravnborg.org>
References: <E1HhT90-0001dW-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1HhT90-0001dW-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 06:18:02PM +0200, Miklos Szeredi wrote:
> 
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> I get lot's of these on i386:
> 
> In file included from include/asm/atomic.h:10,
>                  from include/linux/file.h:9,
>                  from mm/fadvise.c:12:
> include/asm/arch/atomic.h: In function ‘atomic_add_unless’:
> include/asm/arch/atomic.h:240: warning: implicit declaration of function ‘cmpxchg’
> [...]
> 
> The problem seems to be that <asm-i386/atomic.h> assumes that
> <asm/processor.h> pulls in <asm/system.h>.

Then atomic.h should include system.h and not rely on someone else doing it.
Yes - then system.h may be included twice but that's ok.

	Sam
