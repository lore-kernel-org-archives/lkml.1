Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbXIXOfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbXIXOfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 10:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXIXOfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 10:35:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34745 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbXIXOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 10:35:12 -0400
Date: Mon, 24 Sep 2007 07:34:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
Message-ID: <20070924073447.5669fc0d@laptopd505.fenrus.org>
In-Reply-To: <20070923231713.f81ee0db.akpm@linux-foundation.org>
References: <20070920195249.852667D5@kernel>
	<20070920195320.38C8E20D@kernel>
	<20070923231713.f81ee0db.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It look like a false positive to me, but really, for a patchset of
> this complexity and maturity I cannot fathom how it could have
> escaped any lockdep testing.

the code tries to implement per cpu spinlocks, or rather it tries
to bring back the brlocks from way past.... cute.

we can educate lockdep about this quite easily; but isn't there some
primitive already in existence that we can use?

