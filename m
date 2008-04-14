Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbYDNPs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbYDNPs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYDNPst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:48:49 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:40689 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235AbYDNPss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:48:48 -0400
From: Frans Pop <elendil@planet.nl>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Date: Mon, 14 Apr 2008 17:48:43 +0200
User-Agent: KMail/1.9.9
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <200804021524.27222.elendil@planet.nl> <200804131559.21664.elendil@planet.nl> <20080414135214.GC7385@csclub.uwaterloo.ca>
In-Reply-To: <20080414135214.GC7385@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141748.44306.elendil@planet.nl>
X-OriginalArrivalTime: 14 Apr 2008 15:48:46.0571 (UTC) FILETIME=[064E23B0:01C89E47]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, you wrote:
> > I also think the way I've implemented in the Debian installer should be
> > relatively safe:
> > 1) ide-generic is only loaded _after_ any otherwise detected modules
> > 2) it is only loaded if an ISA bus is present
> > 3) it is only included in the initrd for the installed system if
> > loading it in the installer resulted in additional block devices
> > appearing
>
> OK, great for x86 perhaps, what about other systems?

As I've said before, that needs testing.

> In the past debian would load ide-generic last.  It worked great.  Keep
> doing that.  I am not aware of loading ide-generic after all the other
> drivers ever causing any harm in the older debian installers.

Maybe not, but having it loaded in _every_ installed Debian system even when 
it was completely unused is definitely something we want to get rid of.

Note that the old behavior relied on the fact that initramfs-tools also 
loaded ide-generic by default, which it now no longer does.

Cheers,
FJP
