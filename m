Return-Path: <linux-kernel-owner+w=401wt.eu-S1761878AbXHYGWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761878AbXHYGWK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 02:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbXHYGV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 02:21:59 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4884 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbXHYGV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 02:21:58 -0400
Message-ID: <46CFCA78.2090500@xs4all.nl>
Date: Sat, 25 Aug 2007 08:21:44 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org, mpm@selenic.com, mb@bu3sch.de
Subject: Re: possible BUG while doing gpg --gen-key
References: <46CF079C.7010304@xs4all.nl> <20070825011419.GL30705@stusta.de>
In-Reply-To: <20070825011419.GL30705@stusta.de>
X-Enigmail-Version: 0.95.3
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
(...)
> Is CONFIG_HW_RANDOM_VIA enabled in your kernel?
> If yes, does disabling it help?

I disabled rngd.
I disabled audio-entropyd.
netdev-random remained in effect.

Now it works:

(...)
Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
You need a Passphrase to protect your secret key.

We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

Not enough random bytes available.  Please do some other work to give
the OS a chance to collect more entropy! (Need 44 more bytes)
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

public and secret key created and signed.

pub   1024D/4A87572B 2007-08-25
      Key fingerprint = 534F A772 774A 9C7D E10B  FCBF A28E 233F 4A87 572B
uid                  root! <root@localhost>
sub   2048g/E1BCAD7A 2007-08-25




It even complains about a lack of entropy.
