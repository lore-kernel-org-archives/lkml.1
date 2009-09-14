Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbZINHxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbZINHxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbZINHxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:53:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:35377 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbZINHxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:53:22 -0400
Message-ID: <4AADF4E2.9030407@kernel.org>
Date: Mon, 14 Sep 2009 16:46:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: tfjellstrom@shaw.ca
CC: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org,
       Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
References: <4A950FA6.4020408@redhat.com> <20090907114442.GG18831@arachsys.com> <20090907165504.GJ31003@lifeintegrity.com> <200909071726.56432.tfjellstrom@shaw.ca>
In-Reply-To: <200909071726.56432.tfjellstrom@shaw.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 14 Sep 2009 07:46:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thomas Fjellstrom wrote:
> I have the same issue with a single WD 2TB Green drive. Technically two, but 
> it always only gets errors from the same drive, so I was assuming it was the 
> drive. I only have to setup the raid0 array, and put some light load on it for 
> the kernel to start complaining, and eventually it just kicks the drive 
> completely with the following messages:
> 
> sd 3:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> end_request: I/O error, dev sdb, sector 202026972
> 
> The drive does work fine prior to the frozen timeout errors. And I was using 
> it in windows (same raid0 config) just fine with no errors what so ever.

Can you post full dmesg output?  The above doesn't tell much about ATA
side of things.

Thanks.

-- 
tejun
