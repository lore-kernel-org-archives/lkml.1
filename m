Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbYAaRgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbYAaRgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbYAaRgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:36:35 -0500
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:58981 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbYAaRge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:36:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=KyZuxkWNPPPtwDdD7ofDNoiWXS8W2gWGviATOmFXWSTslrnNdtVymodc4pULvx4b;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Thu, 31 Jan 2008 12:36:27 -0500
From: Bill Fink <billfink@mindspring.com>
To: Bruce Allen <ballen@gravity.phys.uwm.edu>
Cc: SANGTAE HA <sangtae.ha@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: e1000 full-duplex TCP performance well below wire speed
Message-Id: <20080131123627.599be68f.billfink@mindspring.com>
In-Reply-To: <Pine.LNX.4.63.0801310951060.10967@trinity.phys.uwm.edu>
References: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu>
	<20080130.055333.192844925.davem@davemloft.net>
	<Pine.LNX.4.63.0801300758020.11487@trinity.phys.uwm.edu>
	<20080130082136.1017631d@deepthought>
	<Pine.LNX.4.63.0801301610240.19938@trinity.phys.uwm.edu>
	<649aecc70801301617m6331bcb8i8ce60366e182c739@mail.gmail.com>
	<20080131064533.ef0ae932.billfink@mindspring.com>
	<Pine.LNX.4.63.0801310951060.10967@trinity.phys.uwm.edu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d362fef374961ea41e0b9370f2468fb2c350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.55.21.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruce,

On Thu, 31 Jan 2008, Bruce Allen wrote:

> > I see similar results on my test systems
> 
> Thanks for this report and for confirming our observations.  Could you 
> please confirm that a single-port bidrectional UDP link runs at wire 
> speed?  This helps to localize the problem to the TCP stack or interaction 
> of the TCP stack with the e1000 driver and hardware.

Yes, a single-port bidirectional UDP test gets full GigE line rate
in both directions with no packet loss.

[bill@chance4 ~]$ nuttcp -f-beta -Itx -u -Ru -w2m 192.168.6.79 & nuttcp -f-beta -Irx -r -u -Ru -w2m 192.168.6.79
tx:  1187.0078 MB /  10.04 sec =  992.0550 Mbps 19 %TX 7 %RX 0 / 151937 drop/pkt 0.00 %loss
rx:  1187.1016 MB /  10.03 sec =  992.3408 Mbps 19 %TX 7 %RX 0 / 151949 drop/pkt 0.00 %loss

						-Bill
