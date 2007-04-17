Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbXDQN5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbXDQN5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbXDQN5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:57:08 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:43058 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbXDQN5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:57:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=srCZw3fMs7H9+u8XK8/Fh+slTRWbbZfpusqY4imEFNR202165cZpRKSZvQl8akjQdl/LhgCru7yqL//HqkCCzLGp0v1ZpPV0+r1mdyXOwxSwpMv9H+O+/fbwm++Gm4Jre5mVic5IzgSU1SaNk06z7BJ8acwl87ahjfgEfm3o18U=
Message-ID: <38b2ab8a0704170657x2ec8177dvea08e39d638007f3@mail.gmail.com>
Date: Tue, 17 Apr 2007 15:57:05 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <20070417130431.GA8685@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com>
	 <E1Hco0p-0007np-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704141410q65f55381w26527aeb10fb4988@mail.gmail.com>
	 <20070415075201.GA1644@gondor.apana.org.au>
	 <38b2ab8a0704160137g1ef0713fl943c51ed9049212b@mail.gmail.com>
	 <20070417004117.GA16513@gondor.apana.org.au>
	 <38b2ab8a0704170536x15920b15xedfd518cad50cee@mail.gmail.com>
	 <20070417130431.GA8685@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > OK, I tried to cook up something very simple. Since I don't know this
> > code, please be indulgent when reading the following patch ;)
>
> Which means that after one has loaded ecryptfs module it can not use
> ipsec and dm-crypt if there is only one crypto algo registered...
>

That's actually the goal, but I agree we would need a flag to pass
when loading AES module to say "I want an exclusive usage of it and
therefore it can be run faster".

If you have several users of AES module, you can choose (a) use the
no-optimized version for all users or (b) choose which user needs to
be run quickly and make it exclusively use the AES hw module; the
others users would use the generic AES (the slower one).

-- 
Francis
