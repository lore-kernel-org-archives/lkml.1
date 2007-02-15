Return-Path: <linux-kernel-owner+w=401wt.eu-S932865AbXBOXri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865AbXBOXri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932868AbXBOXri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:47:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39074 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932865AbXBOXrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:47:37 -0500
Date: Thu, 15 Feb 2007 15:44:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: sparse chokes on arch/i386/kernel/i8253.c (was: 2.6.20-mm1)
Message-Id: <20070215154418.88edfcbc.akpm@linux-foundation.org>
In-Reply-To: <20070215224656.GB6297@Krystal>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<45D483D7.2040609@imap.cc>
	<20070215144142.0c13580a.akpm@linux-foundation.org>
	<20070215224656.GB6297@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 17:46:56 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > Me too.  It's due to the linux-kernel-markers patches.  Mathieu, can you
> > take a look please?
> 
> I will give a deeper look in sparse, but I should say up front that I
> add this to the root build tree Makefile :
> 
> LINUXINCLUDE    := -Iinclude \
>                    $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
>                    -include include/linux/autoconf.h \
>                    -include linux/marker.h
> 
> I guess sparse is maybe not using this Makefile or variable ?

ow, that's going to hurt - this stuff is complex and fragile.

For what reason was that change made?

Pleeze, tricky things like this should be changelogged - we shouldn't need
to ask.  I missed it.


