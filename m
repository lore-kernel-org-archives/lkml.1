Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYKSOFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYKSOFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYKSOEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:04:54 -0500
Received: from stag.SEAS.UPENN.EDU ([158.130.70.79]:39098 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbYKSOEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:04:54 -0500
Message-ID: <49241D02.6020602@seas.upenn.edu>
Date: Wed, 19 Nov 2008 09:04:50 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n-trig digitizer quirks
References: <Pine.LNX.4.61.0811141207210.12963@minus.seas.upenn.edu> <alpine.LNX.1.10.0811181525490.19853@jikos.suse.cz> <49232910.2030309@seas.upenn.edu> <alpine.LNX.1.10.0811191355280.19853@jikos.suse.cz> <492417D4.4090103@seas.upenn.edu> <alpine.LNX.1.10.0811191451000.19853@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0811191451000.19853@jikos.suse.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

>> Also, if you do prefer using driver data like that, is the probe 
>> function necessary to make it work?
> 
> Probe function is necesary, you need to parse the report descriptor 
> (hid_parse()), activate the hardware (hid_hw_start()), etc.

Just to confirm then, its not necessary if I'm not checking the driver data for the quirk?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkkkHQEACgkQwuRiAT9o60+WHACg8N419HjyNxVeX/ozhRH7Wdrx
J80AoLXsSnLSAidbNYM6BID5j6OMh4ny
=dk3Z
-----END PGP SIGNATURE-----
