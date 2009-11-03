Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZKCPce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZKCPce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZKCPcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:32:33 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:33424 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753846AbZKCPcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:32:31 -0500
Date: Tue, 3 Nov 2009 10:32:33 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: padlock-aes: Use the correct mask when
	checking whether copying is required
Message-ID: <20091103153233.GB9186@gondor.apana.org.au>
References: <200910272325.n9RNPYfr002918@int-mx08.intmail.prod.int.phx2.redhat.com> <20091028072559.GA15131@gondor.apana.org.au> <20091102172650.6af2d177@katamari.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102172650.6af2d177@katamari.usersys.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 05:26:50PM -0500, Chuck Ebbert wrote:
> crypto: padlock-aes: Use the correct mask when checking whether copying is required
> 
> Masking with PAGE_SIZE is just wrong...
> 
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

Applied to crypto-2.6.  Thanks Chuck!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
