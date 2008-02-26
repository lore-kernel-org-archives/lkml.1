Return-Path: <linux-kernel-owner+w=401wt.eu-S1763592AbYBZSxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763592AbYBZSxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbYBZSxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:53:45 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:55325 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251AbYBZSxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:53:44 -0500
Date: Tue, 26 Feb 2008 21:52:40 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Adrian Bunk <bunk@kernel.org>
Cc: Martin Michlmayr <tbm@cyrius.com>, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Ralf Baechle <ralf@linux-mips.org>, linux-crypto@vger.kernel.org
Subject: Re: [2.6.25 patch] drivers/crypto/hifn_795x.c: fix 64bit division
Message-ID: <20080226185240.GA2521@2ka.mipt.ru>
References: <20080226122100.GB22699@deprecation.cyrius.com> <20080226153421.GB10717@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226153421.GB10717@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian.

On Tue, Feb 26, 2008 at 05:34:21PM +0200, Adrian Bunk (bunk@kernel.org) wrote:
> Using ndelay() with a 64bit variable as parameter can result in build 
> errors like the following on some 32bit systems when it results in a 
> 64bit division:
> 
> <--  snip  -->
> 
>  ...
>   MODPOST 759 modules
> ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
> 
> <--  snip  -->
> 
> Reported by Martin Michlmayr.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Yep, ndelay() uses division, thanks a lot Adrian for spotting this.

Herbert, please apply.

ACK.

-- 
	Evgeniy Polyakov
