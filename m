Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbYBDUZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbYBDUZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbYBDUZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:25:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:14567 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544AbYBDUZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:25:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jA+1+caCgW8svWYZcer3DOQ5pxfwkpqaPrXsH4TGNdhWKWP2CVSPGpwFjr0pcRAAJwqRsTDeNaAN7DM5HY9PyAFjgmCvtM4Bw/WQPr+WcPwNGHqml3mMjumtnQlZEz5mCPHAjf/Xmju0Tx8eJpQs35NLiypjwX+3p0tjEml2L9I=
Message-ID: <47A774AB.5060008@gmail.com>
Date: Mon, 04 Feb 2008 21:25:15 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?ISO-8859-2?Q?=22Oliver_Pinter_=28Pint=E9r_Oliv=E9r=29=22?= 
	<oliver.pntr@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
       Bruno Randolf <bruno@thinktube.com>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ath5k-devel@lists.ath5k.org
Subject: Re: [Wireless, ath5k] 2.6.24-git13 9135f1901ee6449dfe338adf6e40e9c2025b8150
References: <6101e8c40802040600q804e40cs97d0031920e58d9d@mail.gmail.com>
In-Reply-To: <6101e8c40802040600q804e40cs97d0031920e58d9d@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2008 03:00 PM, Oliver Pinter (Pintér Olivér) wrote:
> git top: 9135f1901ee6449dfe338adf6e40e9c2025b8150
> 
> [  399.582185] wpa_supplicant[4383]: segfault at 30 ip 080697ca sp
> bf87a690 error 4 in wpa_supplicant[8048000+4c000]
> [  406.277199] wpa_supplicant[4384]: segfault at 30 ip 080697ca sp
> bfc13a30 error 4 in wpa_supplicant[8048000+4c000]
> [  407.586375] wpa_supplicant[4385]: segfault at 30 ip 080697ca sp
> bf9ed000 error 4 in wpa_supplicant[8048000+4c000]
> [  411.671037] wpa_supplicant[4386]: segfault at 30 ip 080697ca sp
> bf8f3710 error 4 in wpa_supplicant[8048000+4c000]
> [  412.569843] wpa_supplicant[4387]: segfault at 30 ip 080697ca sp
> bfc19a30 error 4 in wpa_supplicant[8048000+4c000]
> [  413.118874] wpa_supplicant[4388]: segfault at 30 ip 080697ca sp
> bfc9cab0 error 4 in wpa_supplicant[8048000+4c000]

Seems like wpa_supplicant is broken. Is this a regression?

> home:~# wpa_supplicant -Dwext -iath0 -c /etc/wpa_supplicant/wpa_supplicant.conf

ath0? udev renamed it?

> ioctl[SIOCSIWAUTH]: Operation not supported
> WEXT auth param 4 value 0x0 - bind(PF_UNIX): Address already in use

4 - 0x0 is TKIP, nothing we should worry about.

> ctrl_iface exists and seems to be in use - cannot override it
> Delete '/var/run/wpa_supplicant/ath0' manually if it is not used anymore
> Failed to initialize control interface '/var/run/wpa_supplicant'.
> You may have another wpa_supplicant process already running or the file was
> left by an unclean termination of wpa_supplicant in which case you will need
> to manually remove this file before starting wpa_supplicant again.

Have you?

I guess ltrace would help here. And maybe strace...
