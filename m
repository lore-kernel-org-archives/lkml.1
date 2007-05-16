Return-Path: <linux-kernel-owner+w=401wt.eu-S1762167AbXEPRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762167AbXEPRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbXEPRJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:09:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44101 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756247AbXEPRJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:09:19 -0400
Date: Wed, 16 May 2007 10:06:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1
Message-Id: <20070516100632.391f5459.akpm@linux-foundation.org>
In-Reply-To: <1179334843.5854.28.camel@localhost.localdomain>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	<20070516095018.6f0048bc.randy.dunlap@oracle.com>
	<1179334843.5854.28.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 18:00:43 +0100 Richard Purdie <rpurdie@openedhand.com> wrote:

> On Wed, 2007-05-16 at 09:50 -0700, Randy Dunlap wrote:
> > On Tue, 15 May 2007 20:19:14 -0700 Andrew Morton wrote:
> > 
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
> > 
> > LZO build fails on allyesconfig:
> > 
> > lib/built-in.o: In function `lzo1x_1_compress':
> > lib/lzo/minilzo.c:724: multiple definition of `lzo1x_1_compress'                           fs/built-in.o:fs/reiser4/plugin/compress/minilzo.c:1307: first defined here
> > ld: Warning: size of symbol `lzo1x_1_compress' changed from 1541 in fs/built-in.o to 244 in lib/built-in.o
> > lib/built-in.o: In function `lzo1x_decompress':                                            lib/lzo/minilzo.c:885: multiple definition of `lzo1x_decompress'
> > fs/built-in.o:fs/reiser4/plugin/compress/minilzo.c:1466: first defined here                ld: Warning: size of symbol `lzo1x_decompress' changed from 1047 in fs/built-in.o to 678 in lib/built-in.o
> > make: *** [.tmp_vmlinux1] Error 1
> > make: Target `all' not remade because of errors.
> 
> Looks like reiser4 contains a copy of minilzo used as some kind of
> compression plugin. It can be dropped in favour of the version in
> lib/lzo/, they'll be compatible.
> 
> Andrew: Do you want a patch to remove it from reiser4?
> 

yes please.
