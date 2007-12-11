Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbXLKUJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbXLKUJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 15:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXLKUJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 15:09:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:14115 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbXLKUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 15:09:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kXLwhrW7+hi1+B4gp/ThcjMLQD4wmP6wPbNU99e2x8rp53l8MeblfTT9Lwu8u29JjRsSdJLlNoQAjLFkI8U+ivN10fYArD3gVgZ83ywz1evdBdMYChY9KiPc7b6ALvFJmkURygfF78I4JFf7+oIu3oA3SbULGyzde7LOEK2E/Pk=
Message-ID: <2c0942db0712111202p2efea8d7j21a04c8ec2ead04b@mail.gmail.com>
Date: Tue, 11 Dec 2007 12:02:14 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Phillip Susi" <psusi@cfl.rr.com>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Cc: "Theodore Tso" <tytso@mit.edu>, "Matt Mackall" <mpm@selenic.com>,
       "Marc Haber" <mh+linux-kernel@zugschlus.de>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Adrian Bunk" <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <475EE920.7000108@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204114125.GA17310@torres.zugschlus.de>
	 <20071204161811.GB15974@stusta.de>
	 <20071204164720.6e4dc2c4@the-village.bc.nu>
	 <475599D6.4030008@cosmosbay.com> <20071205212646.GP17536@waste.org>
	 <20071209124200.GA31147@torres.zugschlus.de>
	 <20071211013414.GS17037@thunk.org> <475EE920.7000108@cfl.rr.com>
X-Google-Sender-Auth: 367926a675b65a3b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 11, 2007 11:46 AM, Phillip Susi <psusi@cfl.rr.com> wrote:
> Theodore Tso wrote:
> > Note that even paranoid applicatons should not be using /dev/random
> > for session keys; again, /dev/random isn't magic, and entropy isn't
> > unlimited. Instead, such an application should pull 16 bytes or so,
> > and then use it to seed a cryptographic random number generator.
>
> What good does using multiple levels of RNG do?  Why seed one RNG from
> another?  Wouldn't it be better to have just one RNG that everybody
> uses?

Not all applications need cryptographically secure random numbers.
Sometimes, you just want a random number to seed your game RNG or a
monte carlo simulator.
