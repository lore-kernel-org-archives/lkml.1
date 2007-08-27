Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXH0PTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXH0PTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbXH0PSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:18:51 -0400
Received: from iona.labri.fr ([147.210.8.143]:43540 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbXH0PSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:18:50 -0400
Date: Mon, 27 Aug 2007 16:59:12 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       dtor@mail.ru, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Console keyboard events and accessibility
Message-ID: <20070827145912.GB3268@implementation.ifsic.univ-rennes1.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	dtor@mail.ru, Jiri Kosina <jkosina@suse.cz>
References: <20070821005718.GD3658@interface.famille.thibault.fr> <20070821130233.58faaa8a.akpm@linux-foundation.org> <20070821202251.GB3658@interface.famille.thibault.fr> <20070825010704.GK30705@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070825010704.GK30705@stusta.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Adrian Bunk, le Sat 25 Aug 2007 03:07:04 +0200, a écrit :
> > If they
> > remain in -mm for some time and people don't complain, well that's good
> > too: at least we know how speakup may hook into the kernel when it gets
> > merged.
> >...
> 
> Without any users it's dead code noone uses,

Not so much dead: the notify chain will get called anyway, taking
spinlocks, etc. even if nothing is really called.  And people can see
the patches and complain if they think they're bad.

> BTW: Are these the speakup patches that were in -ac five years ago?

No, they are some rework of the way Speakup glues into the kernel.

Samuel
