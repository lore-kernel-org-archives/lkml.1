Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZG2LCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZG2LCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZG2LCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:02:54 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34251 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123AbZG2LCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:02:53 -0400
Date: Wed, 29 Jul 2009 13:02:52 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: slqb enables interrupts very early
Message-ID: <20090729110252.GA4414@Chamillionaire.breakpoint.cc>
References: <20090725180321.GA24814@Chamillionaire.breakpoint.cc> <4A6D59B6.3040400@cs.helsinki.fi> <20090729065824.GE25390@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090729065824.GE25390@wotan.suse.de>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin | 2009-07-29 08:58:24 [+0200]:

>We need it when called from kmem_cache_create, but not from
>the rest of kmem_cache_init. Thanks for finding this, how
>about this?
Seems to be fine. The box boots and warning is gone.

Sebastian
