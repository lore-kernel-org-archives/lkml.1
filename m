Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbXHTNTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbXHTNTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 09:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbXHTNTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 09:19:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbXHTNTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 09:19:07 -0400
Date: Mon, 20 Aug 2007 15:19:00 +0200
From: Markus Dahms <mad@automagically.de>
To: Chris Newport <crn@netunix.com>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: possible endless loop in PROM initialization
Message-ID: <20070820131900.GA12305@vimes.madsworld.lan>
References: <20070820075949.GA5927@vimes.madsworld.lan> <20070820.010622.41634915.davem@davemloft.net> <20070820105320.GB4911@vimes.madsworld.lan> <46C97E7F.3010604@netunix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C97E7F.3010604@netunix.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Provags-ID: V01U2FsdGVkX1+99Eo1dtfQzgL5jmBK5mWwYOZO9rR/U5qaNM8
 86CH9pnIf5uxb3ecKZdXcL5v9jl/ZLIZ3V/RDS4YDW/yIsoe0v
 /Vo3RtGJce7fBtsJPqVVw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> | ok devalias scsi /iommu/sbus/espdma/esp
>> | scsi isn't unique
> Non-unique devalias entries are NASTY. Get rid of them, for example
> your second definition of scsi could be changed to scsidisk.

Yes, it is nasty and I don't really want to use it. But it is possible
and IMHO Linux should handle it one way or the other.

Originally I tried to workaround an Oops in esp on the Classic X which
I connected to some broken PROM entries. The PROM booted from SCSI disk
(using another device path as the scsi aliases are broken or so), but
Linux crashes on loading the SCSI driver. As already said now I use the
"recommended workaround": patching the Classic X to be a Classic.

Markus

