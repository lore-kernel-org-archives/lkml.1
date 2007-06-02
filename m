Return-Path: <linux-kernel-owner+w=401wt.eu-S1763900AbXFBXYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763900AbXFBXYf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 19:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762521AbXFBXY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 19:24:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:14261 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762288AbXFBXY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 19:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Ll0Jx/sYtDxT5wHHCOTkk/gzxX3dbUvYdgdU0uemN2nE7MEUzyEilC1yJPtr1Q4WD0ckfExv7aJc6iFm+tzwx7t3S4I56kECcun2s7oECGOP53cMMPKZxKypRZqntUVsOTRMEuxxcXlABCPXdbfD/+qZ7tHqwi1mJEsnNwIazPs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Geller Sandor <wildy@petra.hos.u-szeged.hu>
Subject: Re: HPT374 IDE problem with 2.6.21.* kernels
Date: Sun, 3 Jun 2007 01:38:15 +0200
User-Agent: KMail/1.9.6
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <Pine.LNX.4.62.0705301112170.1260@petra.hos.u-szeged.hu> <46608EFE.1030202@ru.mvista.com> <Pine.LNX.4.62.0706020035200.19399@petra.hos.u-szeged.hu>
In-Reply-To: <Pine.LNX.4.62.0706020035200.19399@petra.hos.u-szeged.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706030138.15353.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 02 June 2007, Geller Sandor wrote:
> On Sat, 2 Jun 2007, Sergei Shtylyov wrote:
> 
> >> The log of a typical IDE reset is available here:
> >
> >> http://petra.hos.u-szeged.hu/~wildy/syslog.gz
> >
> >> This was the worst case: the IDE bus was resetted during the system boot.
> >
> >   Could you try setting HPT374_ALLOW_ATA133_6 to 0 in 
> > drivers/ide/pci/hpt366.c and rebuild/reboot the kernel?
> 
> 
> Hi Sergei,
> 
> This looks promising. Using a vanilla 2.6.22-rc3 I was able to reproduce 
> the problem within a few seconds. With the above modification the machine 
> is running under heavy disk I/O without problems since 30 minutes...

Did it fix the problem for good?

Sergei, do we need to disallow UDMA6 completely on HPT734 or
is it only an issue with some problematic devices (=> blacklist)?

Either way we need to fix it somehow for 2.6.22.

Thanks,
Bart
