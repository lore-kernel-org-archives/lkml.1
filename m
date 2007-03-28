Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXC1Q5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXC1Q5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933191AbXC1Q5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:57:34 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47114 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933159AbXC1Q5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:57:33 -0400
Date: Wed, 28 Mar 2007 18:58:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.21-rc5-mm2] add compile.h dependency for missing_syscalls.o in init/Makefile
Message-ID: <20070328165816.GA14218@uranus.ravnborg.org>
References: <1175097361.5644.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175097361.5644.7.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 11:56:01AM -0400, Lee Schermerhorn wrote:
> PATCH 2.6.21-rc5-mm2:  add compile.h dependency for missing_syscalls.o
> 
> Add a dependency on include/linux/compile.h to missing_syscalls.o
> target in init/Makefile.  Without this, [ia64] build fails with:
> 
> init/missing_syscalls.c:5:27: error: linux/compile.h: No such file or directory
> In file included from init/missing_syscalls.c:97:

Thanks.
But in the end I made another solution that avoids the compile.h
dependency. It is kbuild.git and will appear in next -mm.

	Sam
