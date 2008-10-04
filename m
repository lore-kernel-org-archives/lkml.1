Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbYJDC3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbYJDC3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 22:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYJDC3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 22:29:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:43945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbYJDC3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 22:29:37 -0400
Message-ID: <48E6D481.7050407@kernel.org>
Date: Sat, 04 Oct 2008 11:27:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Tom Mortensen <tmmlkml@gmail.com>, Bill Davidsen <davidsen@tmr.com>,
       Gwendal Grignou <gwendal@google.com>,
       Brian Rademacher <rad@radfiles.net>, linux-ide@vger.kernel.org,
       linux-raid maillist <linux-raid@vger.kernel.org>,
       Linux Kernel Maillist <linux-kernel@vger.kernel.org>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen
References: <3E6D0C24877245C3A5A327129A7B4CA7@909927SOSLA>  <alpine.DEB.1.10.0809220828490.23159@p34.internal.lan>  <5419A02543384E69AF2BA82FF6E66C14@909927SOSLA>  <alpine.DEB.1.10.0809220903400.23159@p34.internal.lan>  <4B1ABD0393EF40FFB0A12242FE8356AF@909927SOSLA>  <alpine.DEB.1.10.0809220915470.23159@p34.internal.lan>  <alpine.DEB.1.10.0809220926240.23159@p34.internal.lan>  <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com>  <48DBAB81.8050900@tmr.com> <48E08E2D.6050905@kernel.org> <a52a95e30809301347s70b57ebfh280a6871329afd72@mail.gmail.com> <alpine.DEB.1.10.0809301715280.14600@p34.internal.lan> <alpine.LNX.2.00.0809301946020.16014@filesrv1.baby-dragons.com> <alpine.DEB.1.10.0810010403500.16900@p34.internal.lan> <alpine.DEB.1.10.0810010710520.22435@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0810010710520.22435@p34.internal.lan>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Oct 2008 02:29:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> [469680.004654] ata2.00: status: { DRDY }
> [469680.004660] ata2: hard resetting link
> [469680.309567] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [469680.333461] ata2.00: configured for UDMA/133
> [469680.333477] ata2: EH complete
> [469680.333461] sd 1:0:0:0: [sdb] 586072368 512-byte hardware sectors
> (300069 MB)
> [469680.340461] sd 1:0:0:0: [sdb] Write Protect is off
> [469680.340461] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [469680.345461] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA

You're leaving the good part out.  Please always attach full kernel
log.

Thanks.

-- 
tejun
