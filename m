Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbXJZNzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbXJZNzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 09:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXJZNzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 09:55:47 -0400
Received: from ro-out-1112.google.com ([72.14.202.177]:51307 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbXJZNzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 09:55:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ssKyvg0kpMT3xA6nQ4krb0lIoBV1k9hKIowE7rv6zVrSfMkYkrmcPrjoD8pQrvB72DqYSf4VYYRy/+5FmkvEwN/G+djRHPNkSa1bOkivrRQ3m6cigysG5UxLbHzikc2EjV2uI7ub12aEkbfKZn2QKD78TFIoNFRo137SyPj9H0Q=
Date: Fri, 26 Oct 2007 21:50:54 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jeff Dike <jdike@addtoit.com>, Blaisorblade <blaisorblade@yahoo.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PROBLEM] UM does not compile on i386
Message-ID: <20071026135054.GC3953@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <84144f020710260558o16238b54y89936bcfc18a0e6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020710260558o16238b54y89936bcfc18a0e6c@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 03:58:04PM +0300, Pekka Enberg wrote:
>Hi,
>
>The current Linus' git does not compile on i386 for UM defconfig:
>
>  CC      init/do_mounts.o
>In file included from init/do_mounts.c:19:
>init/do_mounts.h: In function 'bstat':
>init/do_mounts.h:25: error: storage size of 'stat' isn't known
>init/do_mounts.h:25: warning: unused variable 'stat'
>init/do_mounts.h:33: warning: control reaches end of non-void function
>make[1]: *** [init/do_mounts.o] Error 1
>make: *** [init] Error 2
>
>                                      Pekka

Fixed by Balbir Singh[1].

[1] http://lkml.org/lkml/2007/10/25/181

-- 
May the Source Be With You.
