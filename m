Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbYAaOz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbYAaOz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYAaOzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:55:48 -0500
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:58652
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYAaOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:55:47 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2008 09:55:47 EST
Message-ID: <47A1E026.2070805@roinet.com>
Date: Thu, 31 Jan 2008 09:50:14 -0500
From: David Acker <dacker@roinet.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Bill Fink <billfink@mindspring.com>
CC: SANGTAE HA <sangtae.ha@gmail.com>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: e1000 full-duplex TCP performance well below wire speed
References: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu>	<20080130.055333.192844925.davem@davemloft.net>	<Pine.LNX.4.63.0801300758020.11487@trinity.phys.uwm.edu>	<20080130082136.1017631d@deepthought>	<Pine.LNX.4.63.0801301610240.19938@trinity.phys.uwm.edu>	<649aecc70801301617m6331bcb8i8ce60366e182c739@mail.gmail.com> <20080131064533.ef0ae932.billfink@mindspring.com>
In-Reply-To: <20080131064533.ef0ae932.billfink@mindspring.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Fink wrote:
> If the receive direction uses a different GigE NIC that's part of the
> same quad-GigE, all is fine:
> 
> [bill@chance4 ~]$ nuttcp -f-beta -Itx -w2m 192.168.6.79 & nuttcp -f-beta -Irx -r -w2m 192.168.5.79
> tx:  1186.5051 MB /  10.05 sec =  990.2250 Mbps 12 %TX 13 %RX 0 retrans
> rx:  1186.7656 MB /  10.05 sec =  990.5204 Mbps 15 %TX 14 %RX 0 retrans
Could this be an issue with pause frames?  At a previous job I remember 
having issues with a similar configuration using two broadcom sb1250 3 
gigE port devices. If I ran bidirectional tests on a single pair of 
ports connected via cross over, it was slower than when I gave each 
direction its own pair of ports.  The problem turned out to be that 
pause frame generation and handling was not configured correctly.
-Ack
