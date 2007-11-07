Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbXKGWfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbXKGWfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbXKGWfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:35:00 -0500
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:48641 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754954AbXKGWe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:34:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Lbpp55VpHIjx+EEeeePIvEx2BFpnAMCm0zhZGwkzuADvsYLGPyUZi7IFGAdOm/nnX2WWCiAExlncbHIdysTcmBxF3XZaHAcYLAC32pV8fgGZQ3cHClqzjfa1cHFmkkeJ99eanQ7PSomJ0j9k2UrSa0jYOAvhXqC9WyLV4MaiPMI=  ;
X-YMail-OSG: nGLJA6cVM1l196BLsefbSldZliJHld3eCvBdKgSw.Z6V2HAPr6QRq_elYOUZ7zJ5AzVihhjJeA--
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: build #337 failed for 2.6.24-rc1-gb1d08ac In function `usbnet_set_settings':
Date: Wed, 7 Nov 2007 14:34:52 -0800
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
References: <200711012024.57412.toralf.foerster@gmx.de> <200711021230.22588.david-b@pacbell.net> <20071102195517.GW30287@stusta.de>
In-Reply-To: <20071102195517.GW30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711071434.52607.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > But on the other hand, it seems that only the ASIX code will work
> > right; the DM9601 and MCS7830 Kconfig is different/wrong.
> 
> I'm not seeing the problem.
> 
> Which configuration will be handled wrongly?

Notice how only the ASIX kconfig depended on NET_ETHERNET...
since MII depends on NET_ETHERNET, and (last I knew) the
reverse dependencies didn't capture the complete dependency
tree, selecting only MII would leave out some stuff.


