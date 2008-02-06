Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbYBFKsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbYBFKsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 05:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYBFKsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 05:48:10 -0500
Received: from ns1.suse.de ([195.135.220.2]:39293 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbYBFKsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:48:09 -0500
From: Andreas Schwab <schwab@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Tino Keitel <tino.keitel@gmx.de>, <linux-kernel@vger.kernel.org>,
       ath5k-devel@lists.ath5k.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [RFT 1/1] single_chip test
References: <20080206014131.9d489a34.akpm@linux-foundation.org>
	<1202294560-7313-1-git-send-email-jirislaby@gmail.com>
X-Yow: I've read SEVEN MILLION books!!
Date: Wed, 06 Feb 2008 11:48:06 +0100
In-Reply-To: <1202294560-7313-1-git-send-email-jirislaby@gmail.com> (Jiri
	Slaby's message of "Wed\, 6 Feb 2008 11\:42\:40 +0100")
Message-ID: <jezluetl7d.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> @@ -210,12 +205,16 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>  	}
>  
>  	/* Identify single chip solutions */
> -	if((srev <= AR5K_SREV_VER_AR5414) &&
> -	(srev >= AR5K_SREV_VER_AR2424)) {
> -		ah->ah_single_chip = true;
> -	} else {
> -		ah->ah_single_chip = false;
> -	}
> +	ah->ah_single_chip = !!(srev >= AR5K_SREV_VER_AR2424 &&
                             ^^

This is useless.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
