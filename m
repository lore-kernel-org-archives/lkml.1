Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYLVWh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYLVWh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbYLVWhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:37:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:60291 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbYLVWhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:37:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=r7ZlYf0IMLYo0LG19k9rmQ1NxnGG2hDcHOZd6WH0sUyeJL5oQPvYcIiojnGpBXTHef
         iMUbOyEHlsu7V9ajQgISPlzViYpjmb6v0DVdvbS5qmISQG8pg16URVK1UvyghyUiTgyW
         SVAY3PhWsXTQ1ydkA/UXS8WuZS10YxuRBtwHo=
Subject: Re: [ath5k-devel] ath5k_pci: gain calibration timeout / unable to
 reset hardware -11
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <bcopeland@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Soeren Sonnenburg <kernel@nn7.de>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <b6c5339f0812221348o411c4fabse2d0138acfb4f87f@mail.gmail.com>
References: <1229923913.3886.7.camel@localhost>
	 <20081222125819.7353d172.akpm@linux-foundation.org>
	 <4950087E.3080505@gmail.com> <49500906.70309@gmail.com>
	 <b6c5339f0812221348o411c4fabse2d0138acfb4f87f@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Dec 2008 00:37:05 +0200
Message-Id: <1229985425.17866.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-22 at 16:48 -0500, Bob Copeland wrote:
> On Mon, Dec 22, 2008 at 4:39 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> >>
> >> Does the _HW lockup_ happen even with 2.6.28? The lockup should be gone there
> >> (with the messages still present).
> >
> > I see Bob already replied, ignore me, he knows better.
> 
> I thought Felix's patch had gone into .28, but in fact it hasn't.
> We should probably get it in or queue it for .28.1 -- it's a two
> liner that will fix a lot of people's setups.
> 
> John, if you're reading, that's 23c401574b16cb2b6d2231ba405ebf85b8c87de5
> in wireless-testing.
> 
> The lockup can still occur, but it's a lot less frequent with his patch.
> 

Happens about 1 in 10 times on resume from ram.

Best regards,
	Maxim Levitsky

