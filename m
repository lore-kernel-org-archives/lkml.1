Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbYLVWjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbYLVWjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbYLVWjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:39:00 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:59291 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbYLVWjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:39:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LwK1Z5bP8KY2WUV8QBkLU2AsDTXH5CTQDdCrvtSty1SVdg7ezSD9dfQlIedSP57Lzi
         RWcAr6bqfxSj6um4r+U5AAaLyVMM88EqBfCFk0V/nteK45Nxre3hQvlCAASeSSekJ3rd
         nEGGWKvNdEek76cPdT1w7SQcFWrHIJMP/nVao=
Message-ID: <40f31dec0812221438k43f69c6dw3f011a58128edf23@mail.gmail.com>
Date: Tue, 23 Dec 2008 00:38:58 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <bcopeland@gmail.com>
Subject: Re: [ath5k-devel] ath5k_pci: gain calibration timeout / unable to reset hardware -11
Cc: "Jiri Slaby" <jirislaby@gmail.com>, "Soeren Sonnenburg" <kernel@nn7.de>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <b6c5339f0812221348o411c4fabse2d0138acfb4f87f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229923913.3886.7.camel@localhost>
	 <20081222125819.7353d172.akpm@linux-foundation.org>
	 <4950087E.3080505@gmail.com> <49500906.70309@gmail.com>
	 <b6c5339f0812221348o411c4fabse2d0138acfb4f87f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/22 Bob Copeland <bcopeland@gmail.com>:
> On Mon, Dec 22, 2008 at 4:39 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>>
>>> Does the _HW lockup_ happen even with 2.6.28? The lockup should be gone there
>>> (with the messages still present).
>>
>> I see Bob already replied, ignore me, he knows better.
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

Felix's patch is for Noise Floor calibration timeout which is
non-fatal, here we have a problem with gain offset calibration. If
gain offset calibration fails, we can't have i/q correction and we
can't tune to that channel propertly.

This is a known problem also reported on binary HAL ;-)
http://madwifi-project.org/ticket/1869

we miss something in rf/phy initialization i guess...

_____________________________________________
> ath5k-devel mailing list
> ath5k-devel@lists.ath5k.org
> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
