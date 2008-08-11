Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbYHLO7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbYHLO7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYHLO7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:59:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3543 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752898AbYHLO7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:59:32 -0400
Date: Mon, 11 Aug 2008 18:10:15 +0200
From: Pavel Machek <pavel@suse.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ulrich Drepper <drepper@gmail.com>, austin_zhang@linux.intel.com,
       bunk@kernel.org, dwmw2@infradead.org, davem@davemloft.net,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Message-ID: <20080811161015.GA5240@ucw.cz>
References: <a36005b50808072038w3e88658p6769e1e3779b6cab@mail.gmail.com> <E1KRS7u-0005EP-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KRS7u-0005EP-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-08-08 21:35:30, Herbert Xu wrote:
> Ulrich Drepper <drepper@gmail.com> wrote:
> >
> > I think you want to use
> > 
> >  #define SCALE_F sizeof(unsigned long)
> 
> Yeah in general that's what we should do.  However, this driver
> is specific to Intel x86 CPUs.

I thought we support intel x86 cpus in both 32 and 64bit modes...?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
