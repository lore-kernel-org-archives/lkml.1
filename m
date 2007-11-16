Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbXKPOQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbXKPOQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbXKPOQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:16:32 -0500
Received: from pat.uio.no ([129.240.10.15]:56051 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760132AbXKPOQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:16:31 -0500
Subject: Re: NFS Bug in 2.6.23 ?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Gianluca Alberici <gianluca@abinetworks.biz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <473D626F.1030302@abinetworks.biz>
References: <473D626F.1030302@abinetworks.biz>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 09:16:27 -0500
Message-Id: <1195222587.7653.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.139)
X-UiO-Scanned: 616FC405CC80EC39280EDBB3A25F4872DB7678C8
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 537 total 5180940 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-16 at 10:27 +0100, Gianluca Alberici wrote:
> Hello,
> 
> Got problems with CFS after a kernel upgrade from 2.6.20 to 2.6.23. 
> After a certain amount of time since cattach i get:
> 
> ios:~$ ls /opt/clear/
> ls: /opt/clear/: Not a directory
> 
> stracing the command i get stat64() returning ENOTDIR.
> Applications won't find the directory.
> 
> If i cd into it and ls it is like doing a refresh: everything works 
> again for a certain amount of time, then, again. It reminds me an old 
> version of CFS which used to claim: 'stale NFS file handle'.
> 
> I didnt see any NFS changes in the changeslog of 2.6.23.1 so i decided 
> to POST.
> 
> SOmebody can help ?

Can you send a binary tcpdump illustrating the problem?

  tcpdump -s 9000 -w /tmp/dump.out host cfs-servername

and then run your test...

Cheers
  Trond

