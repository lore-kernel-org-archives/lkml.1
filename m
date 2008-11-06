Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYKFFfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYKFFfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 00:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYKFFfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 00:35:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:37121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYKFFfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 00:35:40 -0500
Date: Wed, 5 Nov 2008 21:36:16 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Keith Owens <kaos@ocs.com.au>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] scripts: script from kerneloops.org to pretty print
 oops dumps
Message-ID: <20081105213616.5390c3a9@infradead.org>
In-Reply-To: <11403.1225944922@ocs10w>
References: <20081105190726.31952581@infradead.org>
	<11403.1225944922@ocs10w>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 15:15:22 +1100
Keith Owens <kaos@ocs.com.au> wrote:

> Arjan van de Ven (on Wed, 5 Nov 2008 19:07:26 -0800) wrote:
> >I had this script lying around (used on kerneloops.org in a slightly
> >modified form, where I use a database as input rather than stdin). I
> >think it's a useful tool, at least I find it extremely useful in
> >turning oopses into an "oh duh yes there" experience...
> >
> >Caveats:
> >* It only works for oopses not-in-modules
> >* It only works nicely for kernels compiled with CONFIG_DEBUG_INFO
> >* It's not very fast.
> 
> Another caveat: "if ($_ =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/)" means
> that it only works on x86_32.
> 

true. I've not tried it/adapted it on any other arch yet.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
