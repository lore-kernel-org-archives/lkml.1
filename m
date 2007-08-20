Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbXHTP0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbXHTP0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbXHTP0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:26:45 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:4573 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753866AbXHTP0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:26:44 -0400
Message-ID: <46C9B25B.9040208@cfl.rr.com>
Date: Mon, 20 Aug 2007 11:25:15 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Robert Hancock <hancockr@shaw.ca>, Brennan Ashton <comphappy@gmail.com>,
       Marty Leisner <leisner@rochester.rr.com>, linux-kernel@vger.kernel.org
Subject: Re: power off disk drives while running
References: <fa.l/ISoqsJwIs1QBGVs0hodyygNPM@ifi.uio.no> <fa.FVj1AVbAlk/6U33GB0rOY45WWqM@ifi.uio.no> <fa.CQDcAiLY+yM/ENberToamsw+vFw@ifi.uio.no> <46C7551E.7090408@shaw.ca> <Pine.LNX.4.64.0708182305220.5186@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708182305220.5186@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Aug 2007 15:25:15.0680 (UTC) FILETIME=[4F08C200:01C7E33E]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15368.001
X-TM-AS-Result: No-0.704600-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> An IDE reset bringing the disk up again -- that does not sound like
> it is powered down. Power down for me means: as if the plug was pulled.

Reset means "power on, initialize power on state".  While shutdown in 
this way, the drive has shut down and is not drawing any power.  The 
reset is required to enable power flow into the drive again so it comes 
online.  Essentially you have a transistor disconnecting the power 
inside the drive, and the reset pulse flips that transistor.


