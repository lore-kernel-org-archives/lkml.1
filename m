Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbZGFSSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbZGFSSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZGFSR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:17:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54971 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751748AbZGFSR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:17:56 -0400
Date: Mon, 6 Jul 2009 19:18:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Guntsche <mike@it-loops.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: BUG: scheduling while atomic
Message-ID: <20090706191852.3e138fc5@lxorguk.ukuu.org.uk>
In-Reply-To: <6BC3DACB-2179-4322-B270-475180CC8AA2@it-loops.com>
References: <23AED400-6DA5-462F-94F0-BEE34AC08A7A@it-loops.com>
	<20090627140643.7140f6a9@lxorguk.ukuu.org.uk>
	<33C7D336-F062-47B3-9033-D3DC465F793C@it-loops.com>
	<20090706074333.GA17276@gondor.apana.org.au>
	<20090706083119.GA17782@gondor.apana.org.au>
	<20090706163239.3f557b45@lxorguk.ukuu.org.uk>
	<20090706181736.766b3e7c@lxorguk.ukuu.org.uk>
	<6BC3DACB-2179-4322-B270-475180CC8AA2@it-loops.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009 20:07:34 +0200
Michael Guntsche <mike@it-loops.com> wrote:

> 
> On Jul 6, 2009, at 19:17, Alan Cox wrote:
> 
> > This is the more drastic way of doing it. I had hoped to put this  
> > off but
> > in fact it cleans stuff up enormously. This has had only basic testing
> > but the underlying idea is to simply remove all the pty special casing
> > that causes messes in the first place.
> <snip>
> 
> Hi Alan,
> 
> Must commit a6540f731d506d9e82444cf0020e716613d4c46c still be reverted  
> with your patch or can it stay in?

Herbert is (as usual ;)) correct that it should be reverted.

Alan
