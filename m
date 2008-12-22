Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYLVVud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYLVVud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbYLVVsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:48:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:24569 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbYLVVss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:48:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i9p++14ShWlUuQKzerCv4MG5mP1k08XUYY14S1xDiz1zrujKlqebjkc+4OVejiGWIj
         dUeVfrtIXPinoCA+Z2/tw+Gs4IvKHsN1g3zTIeLVgeffKp7NwhvMh0CG8/T0Qb3vYrHd
         GLj8K/d7KEHbxaVtQX/zGPAl/99jDZec7ZXx4=
Message-ID: <b6c5339f0812221348o411c4fabse2d0138acfb4f87f@mail.gmail.com>
Date: Mon, 22 Dec 2008 16:48:47 -0500
From: "Bob Copeland" <bcopeland@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [ath5k-devel] ath5k_pci: gain calibration timeout / unable to reset hardware -11
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Soeren Sonnenburg" <kernel@nn7.de>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com
In-Reply-To: <49500906.70309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229923913.3886.7.camel@localhost>
	 <20081222125819.7353d172.akpm@linux-foundation.org>
	 <4950087E.3080505@gmail.com> <49500906.70309@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 4:39 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>
>> Does the _HW lockup_ happen even with 2.6.28? The lockup should be gone there
>> (with the messages still present).
>
> I see Bob already replied, ignore me, he knows better.

I thought Felix's patch had gone into .28, but in fact it hasn't.
We should probably get it in or queue it for .28.1 -- it's a two
liner that will fix a lot of people's setups.

John, if you're reading, that's 23c401574b16cb2b6d2231ba405ebf85b8c87de5
in wireless-testing.

The lockup can still occur, but it's a lot less frequent with his patch.

-- 
Bob Copeland %% www.bobcopeland.com
