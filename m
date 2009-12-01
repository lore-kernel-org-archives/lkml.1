Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZLAH1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZLAH1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZLAH1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:27:13 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:45902 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753148AbZLAH1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:27:13 -0500
Date: Tue, 1 Dec 2009 15:27:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ian Molton <ian.molton@collabora.co.uk>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mpm@selenic.com,
       jeff@garzik.org
Subject: Re: [PATCH 2/2] virtio: Convert virtio-rng to the new API
Message-ID: <20091201072712.GA23449@gondor.apana.org.au>
References: <1259196250-24182-3-git-send-email-ian.molton@collabora.co.uk> <1259577501-17786-1-git-send-email-ian.molton@collabora.co.uk> <1259577501-17786-2-git-send-email-ian.molton@collabora.co.uk> <1259577501-17786-3-git-send-email-ian.molton@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259577501-17786-3-git-send-email-ian.molton@collabora.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 10:38:21AM +0000, Ian Molton wrote:
> 	This patch converts virtio-rng to the new hw_rng API.
> 
> In the process it fixes a previously untriggered buffering bug where the
> buffer is not drained correctly if it has a non-multiple-of-4 length.
> 
> Performance has improved under qemu-kvm testing also.
> 
> Signed-off-by: Ian Molton <ian.molton@collabora.co.uk>

Both patched applied.  Thanks everyone!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
