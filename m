Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYGYO5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYGYO5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYGYO50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:57:26 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:58299 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYGYO5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:57:25 -0400
Date: Fri, 25 Jul 2008 23:59:19 +0900 (JST)
Message-Id: <20080725.235919.36921137.anemo@mba.ocn.ne.jp>
To: Trond.Myklebust@netapp.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26-git] Fix oops on remounting nfsroot
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1216934983.7171.1.camel@localhost>
References: <20080724.185122.139681307.nemoto@toshiba-tops.co.jp>
	<1216934983.7171.1.camel@localhost>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 14:29:43 -0700, Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> > +	if (!options ||
> > +	    (nfsvers == 4 && options4->version == 1) ||
> >  	    (nfsvers <= 3 && options->version >= 1 &&
> >  	     options->version <= 6))
> >  		return 0;
> 
> The above is almost correct. You need to test for options4 if the
> filesystem is NFSv4.

But options == options4 == raw_data ;)

> Marc Zyngier sent me a patch for the same problem a couple of days ago,
> but I have yet to pass it on to Linus.

OK, I'll wait that patch merged.  Thanks.

---
Atsushi Nemoto
