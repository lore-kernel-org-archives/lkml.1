Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbXIXH6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbXIXH6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbXIXH61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:58:27 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41829 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbXIXH60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:58:26 -0400
Date: Mon, 24 Sep 2007 09:59:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Move kasprintf.o to obj-y
Message-ID: <20070924075949.GA1742@uranus.ravnborg.org>
References: <20070924071826.GA6757@localhost.sw.ru> <20070924074110.GA7721@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924074110.GA7721@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 08:41:10AM +0100, Christoph Hellwig wrote:
> On Mon, Sep 24, 2007 at 11:18:26AM +0400, Alexey Dobriyan wrote:
> > Modular puppyvisor started giving linking errors
> > 
> > 	  MODPOST 1 modules
> > 	ERROR: "kasprintf" [drivers/lguest/lg.ko] undefined!
> 
> Please kill lib-y while you're at it.  It's useless and a constant
> source of pain like this.
Kernel-bloat is another "constant source of pain".
But the troubles are that increased blot does not result in compiler erros.

And your proposal to kil lib-y is a counter-act here.

	Sam
