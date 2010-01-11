Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799Ab0AKEkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab0AKEkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 23:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350Ab0AKEkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 23:40:49 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:49571 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0AKEks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 23:40:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=td+bSTYNcGmD9mOBIAygU4SFtzUGNIfwBarBN1+/IqHmrmmBlzVKoLfT05ylPuUBg7
         5Lbj6GB5wDk4d5ZkNEudApf+l7g63Ppef3uzG0i+uNJX77yx8oRaJtyOGoRvbP3rLcrN
         l2EvX1Ef8n4M2jrPs7t4+WE9Rtqa0oacagHyA=
MIME-Version: 1.0
In-Reply-To: <13bb8ce11001101730w640f99p72ecb1204e59f139@mail.gmail.com>
References: <13bb8ce11001101156g3cd88a6bn7c6ce657850ab534@mail.gmail.com>
	 <20100111001745.21d28340@lxorguk.ukuu.org.uk>
	 <13bb8ce11001101730w640f99p72ecb1204e59f139@mail.gmail.com>
Date: Sun, 10 Jan 2010 22:40:46 -0600
Message-ID: <13bb8ce11001102040j37e061fn976ec74595f30232@mail.gmail.com>
Subject: Re: staging/et131x Driver Transmits but does not Receive Packets
From: Daniel Goller <morfic@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Going to get 2.6.29 and 2.6.30 now.

This is going to be a lot of fun...

2.6.29.6 did nothing, but TX Packets count ever so slightly
increasing, all attempts ended in a "Destination host unreachable"
2.6.30.10 actually allowed me to ping another host in the network,
(the restarted by kde) xchat meanwhile reconnected to the znc instance
on the host i was pinging.
I got replies to pings 4, 13 and all else was lost by the time i
pinged the host.

I then blacklisted iwlagn and r8169 and rebooted, retrying 2.6.29.6
and 2.6.30.10 but was no longer able to ping anything. So when it
works and when not is still intermittent. (And the only interfaces up
were eth1 and lo, not eth0 (r8169) or wlan0 (iwlagn) in case someone
wonders)

2.6.29.6 and 2.6.30.10 would allow me to modprobe et131x with
additional debugging info, if you let me know what debug level you
need and what i should be trying on the interface to produce useful
info.

[ 1386.009039] et131x.ko:WARNING:et131x_ioctl Unhandled IOCTL Code: 0x8b27
[ 1386.009859] et131x.ko:WARNING:et131x_ioctl Unhandled IOCTL Code: 0x8b14
[ 1386.010994] et131x.ko:WARNING:et131x_ioctl Unhandled IOCTL Code: 0x8b1a
[ 1386.011943] et131x.ko:WARNING:et131x_ioctl Unhandled IOCTL Code: 0x8b26

I see this repeating a few times now in 2.6.30.6

The one time i did get a reply on my pings and xchat, was just after
trying to switch network cables around. But i have not been able to
reproduce anything in subsequent attempts of replugging/restarting the
interface.

I do not think i am yet at a point where git bisect would be useful.


Thanks,

Daniel
