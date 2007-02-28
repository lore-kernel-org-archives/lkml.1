Return-Path: <linux-kernel-owner+w=401wt.eu-S1751552AbXB1MeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbXB1MeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXB1MeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:34:04 -0500
Received: from sdcrelbas02.europe.hp.net ([15.203.169.188]:34820 "EHLO
	sdcrelbas02.sdc.hp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751552AbXB1MeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:34:03 -0500
X-Greylist: delayed 1748 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 07:34:03 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 13:07:42 +0100
Message-ID: <93C4769E3BED6B42B7203BD6F065654C08C5D6E8@dmoexc01.emea.cpqcorp.net>
In-Reply-To: <45E46976.6060600@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: lanana: Add major/minor entries for PPC QE UART devices
Thread-Index: AcdbMQwUxOaIaaADS4OWsIYw39azXA==
References: <45E46976.6060600@freescale.com>
From: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>
To: "Timur Tabi" <timur@freescale.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Feb 2007 12:04:48.0438 (UTC) FILETIME=[A4C68560:01C75B30]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> --- devices-2.6+.txt	2007-02-22 13:37:18.000000000 -0600
> +++ devices-2.6+.new	2007-02-22 13:42:50.000000000 -0600
> @@ -2770,7 +2770,10 @@
>   		 45 = /dev/ttyMM1		Marvell MPSC - port 1
>   		 46 = /dev/ttyCPM0		PPC CPM (SCC or SMC) -
port 0
>   		    ...
> -		 47 = /dev/ttyCPM5		PPC CPM (SCC or SMC) -
port 5
> +		 49 = /dev/ttyCPM5		PPC CPM (SCC or SMC) -
port 5
> +		 46 = /dev/ttyQE0		PPC QE (UCC) - port 0
> +		    ...
> +		 49 = /dev/ttyQE3		PPC QE (UCC) - port 3
>   		 50 = /dev/ttyIOC0		Altix serial card
>   		    ...
>   		 81 = /dev/ttyIOC31		Altix serial card
>

Got around looking at this one. I'm fine with this approach, but the
CPM5 fix looks wrong. Shouldn't it be:

49 = /dev/ttyCPM3		PPC CPM (SCC or SMC) - port 3

instead?

Thx,
Torben
 

