Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZC2HUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZC2HUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 03:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZC2HUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 03:20:11 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:35260 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751304AbZC2HUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 03:20:10 -0400
Date: Sun, 29 Mar 2009 15:19:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
       "David S. Miller" <davem@davemloft.net>, lho@amcc.com, kaber@trash.net,
       darrenrjenkins@gmail.com, Frank Seidel <frank@f-seidel.de>
Subject: Re: [PATCHv3][trivial] crypto: tcrypt - reduce stack size
Message-ID: <20090329071950.GA11469@gondor.apana.org.au>
References: <49A54C23.8090209@suse.de> <49A5549F.4070304@suse.de> <49A55B5A.70705@suse.de> <20090225153231.GA16691@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225153231.GA16691@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 10:32:31AM -0500, Neil Horman wrote:
> On Wed, Feb 25, 2009 at 03:53:14PM +0100, Frank Seidel wrote:
> > From: Frank Seidel <frank@f-seidel.de>
> > 
> > Applying kernel janitors todos (printk calls need KERN_*
> > constants on linebeginnings, reduce stack footprint where
> > possible) to tcrypts test_hash_speed (where stacks
> > memory footprint was very high (on i386 1184 bytes to
> > 160 now).
> > 
> > Signed-off-by: Frank Seidel <frank@f-seidel.de>
> Looks good, thanks Frank
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Patch applied to cryptodev.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
