Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXKPOVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXKPOVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbXKPOVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:21:05 -0500
Received: from pat.uio.no ([129.240.10.15]:36762 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758412AbXKPOVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:21:04 -0500
Subject: Re: NFS Bug in 2.6.23 ?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: markus reichelt <ml@mareichelt.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071116121148.GI4290@tatooine.rebelbase.local>
References: <473D6B5C.4090701@abinetworks.biz>
	 <20071116121148.GI4290@tatooine.rebelbase.local>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 09:21:03 -0500
Message-Id: <1195222863.7653.18.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.087)
X-UiO-Scanned: 00678CDEC710AEA8CA33B89DEEBDF939F37B3288
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 677 total 5181080 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-16 at 13:11 +0100, markus reichelt wrote:
> * Gianluca Alberici <gianluca@abinetworks.biz> wrote:
> 
> > If i cd into it and ls it is like doing a refresh: everything works
> > again for a certain amount of time, then, again. It reminds me an
> > old version of CFS which used to claim: 'stale NFS file handle'.
> 
> "there are no fish in my pond"
> 
> 
> # CONFIG_NFS_DIRECTIO is not set
> 
> Ive had probs with that option set, disabling did the trick for me.

Huh? Why would directio have anything at all to do with readdir()?

Trond

