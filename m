Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbYKCBg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbYKCBg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 20:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYKCBgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 20:36:44 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43249 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752AbYKCBgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 20:36:44 -0500
Message-ID: <490E559E.7080900@garzik.org>
Date: Sun, 02 Nov 2008 20:36:30 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: add test vectors for skein256/512/1024
References: <20081102161506.GA21940@havoc.gtf.org> <20081102201518.GA23620@Chamillionaire.breakpoint.cc>
In-Reply-To: <20081102201518.GA23620@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Andrzej Siewior wrote:
> I grabed them from http://www.schneier.com/skein.html. The last test vector
> (3) in every category is currently deactivated because it failed always.
> It is unlikely that I made a type because I copy+pasted the tables + vim
> magiced them. So maybe code may missbehave on requests lengths which are
> not a multiple of 4 or the vectors can not be used due to some other
> limitations that I've overseen.
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  crypto/tcrypt.c  |   24 ++++++++
>  crypto/testmgr.c |   27 +++++++++
>  crypto/testmgr.h |  166 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 216 insertions(+), 1 deletions(-)

Nice, thanks!

I'm wondering if the failure has to do with the alignmask value in 
struct crypto_alg for each variant.

	Jeff




