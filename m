Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZLCVRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZLCVRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZLCVRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:17:53 -0500
Received: from swm.pp.se ([212.247.200.143]:45465 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbZLCVRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:17:52 -0500
Date: Thu, 3 Dec 2009 22:17:58 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Andre Tomt <andre@tomt.net>
cc: Jeff Garzik <jeff@garzik.org>, tfjellstrom@shaw.ca,
       linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
In-Reply-To: <4AF0CFE1.8050407@tomt.net>
Message-ID: <alpine.DEB.1.10.0912032214040.23464@uplift.swm.pp.se>
References: <200909090414.41274.tfjellstrom@shaw.ca> <200909091030.13147.tfjellstrom@shaw.ca> <4AA7F965.6020408@garzik.org> <4AF0CFE1.8050407@tomt.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009, Andre Tomt wrote:

> Identical issues with the AOC-SASLP-MV8 card with 8 Seagate Barracuda 
> 7200.11 1.5TB drives using the mvsas driver. Creating a md raid array 
> seems to trigger it nearly instantly, however other loads do not trigger 
> it as fast (if at all, only tested briefly with paralell dd).

Would just like to chime in with a "me too" on this. I've tried both 
ubuntu 9.10 kernel (2.6.31) and their 10.04 pre-alpha (guess it's 
2.6.32-rc8) and mvsas + AOC-SASLP-MV8 is pretty much unusable. If I start 
md creation it stalls immediately and gets nowhere, last time I tried it 
md claimed it had written 160 blocks then it stalled (all drive LEDs on 
the controller is constantly lit).

If I boot without drives and then hot-plug the drives, it immediately 
oops:es.

Any code/fixes I can try, this is a lab machine so I can easily do 
whatever needed with it...

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
