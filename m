Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbZGFSHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbZGFSHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbZGFSHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:07:34 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:45224
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbZGFSHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:07:33 -0400
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Message-Id: <6BC3DACB-2179-4322-B270-475180CC8AA2@it-loops.com>
From: Michael Guntsche <mike@it-loops.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090706181736.766b3e7c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: BUG: scheduling while atomic
Date: Mon, 6 Jul 2009 20:07:34 +0200
References: <23AED400-6DA5-462F-94F0-BEE34AC08A7A@it-loops.com> <20090627140643.7140f6a9@lxorguk.ukuu.org.uk> <33C7D336-F062-47B3-9033-D3DC465F793C@it-loops.com> <20090706074333.GA17276@gondor.apana.org.au> <20090706083119.GA17782@gondor.apana.org.au> <20090706163239.3f557b45@lxorguk.ukuu.org.uk> <20090706181736.766b3e7c@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 6, 2009, at 19:17, Alan Cox wrote:

> This is the more drastic way of doing it. I had hoped to put this  
> off but
> in fact it cleans stuff up enormously. This has had only basic testing
> but the underlying idea is to simply remove all the pty special casing
> that causes messes in the first place.
<snip>

Hi Alan,

Must commit a6540f731d506d9e82444cf0020e716613d4c46c still be reverted  
with your patch or can it stay in?

Kind regards,
Michael 
