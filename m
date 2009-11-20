Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbZKTXBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbZKTXBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 18:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZKTXBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 18:01:12 -0500
Received: from solo.fdn.fr ([80.67.169.19]:57689 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbZKTXBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 18:01:11 -0500
Date: Sat, 21 Nov 2009 00:01:14 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Fix braille keyboard keysym generation
Message-ID: <20091120230114.GN4986@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
References: <20091117135111.GA14470@const.bordeaux.inria.fr> <20091120131954.0e61c0b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091120131954.0e61c0b6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton, le Fri 20 Nov 2009 13:19:54 -0800, a écrit :
> >  	if (keycode >= NR_KEYS)
> >  		if (keycode >= KEY_BRL_DOT1 && keycode <= KEY_BRL_DOT8)
> > -			keysym = K(KT_BRL, keycode - KEY_BRL_DOT1 + 1);
> > +			keysym = U(K(KT_BRL, keycode - KEY_BRL_DOT1 + 1));
> >  		else
> >  			return;
> >  	else
> 
> Sorry, but I cannot work out (with a reasonable amount of effort) what
> the user-visible effects of this bug are likely to be.  So I am not in
> a position to decide which kernel(s) this patch should be merged into.

It will make braille keyboards actually work.  Apparently I had never
really tried it and so it has never worked up to now.

> Please be careful to include this aspect in the changelog when
> appropriate, thanks.

Right, sorry.  Braille keyboards announced as KEY_BRL_DOT* are still
pretty rare (that's why the bug completely went unnoticed from the
start), so it's maybe not worth including the patch in the stable
kernels, but making it for 2.6.32 would be a good thing.

Samuel
