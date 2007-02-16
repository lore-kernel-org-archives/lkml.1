Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbXBPBWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbXBPBWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbXBPBWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:22:51 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42134 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbXBPBWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:22:51 -0500
Date: Thu, 15 Feb 2007 17:22:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: sparse chokes on arch/i386/kernel/i8253.c (was: 2.6.20-mm1)
Message-Id: <20070215172242.ab7a6f1e.akpm@linux-foundation.org>
In-Reply-To: <20070216003739.GC9851@Krystal>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<45D483D7.2040609@imap.cc>
	<20070215144142.0c13580a.akpm@linux-foundation.org>
	<20070215224656.GB6297@Krystal>
	<20070215154418.88edfcbc.akpm@linux-foundation.org>
	<20070216003739.GC9851@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 19:37:39 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > For what reason was that change made?
> > 
> 
> It was made so that we can use the markers in C code without actually
> including marker.h everywhere. I am sure someone has a better way to do
> it : I would be happy to use this-nice-build-system-feature-I-missed to
> have marker.h included.

Oh.  One could whack it in kernel.h: pretty much everything includes that.

But it'd be better to simply require that the clients of this
infrastructure include the appropriate header file.  We do that for
everything else and markers aren't special in this regard.
