Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZFRV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZFRV4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZFRV4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:56:03 -0400
Received: from smtp4.netcologne.de ([194.8.194.137]:47430 "EHLO
	smtp4.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZFRV4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:56:01 -0400
From: Mathias Kretschmer <mathias@blx4.net>
Organization: BLX4
To: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Thu, 18 Jun 2009 23:55:51 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Samad <alex@samad.com.au>, Dave Chinner <david@fromorbit.com>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <200906092111.54073.mathias@blx4.net> <alpine.DEB.1.10.0906091521470.9067@router.windsormachine.com>
In-Reply-To: <alpine.DEB.1.10.0906091521470.9067@router.windsormachine.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906182355.57100.mathias@blx4.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009 21:22:16 Mike Dresser wrote:
> On Tue, 9 Jun 2009, Mathias Kretschmer wrote:
> > machine is stable for the last 36 hours with nfs turned off.
>
> Is the system load different with nfs off? (no clients accessing it, etc?)

Yep.

I've upgraded to 2.6.30 two days ago. So far, so good.

I've ran three Gentoo 'emerge world' sessions in parallel while forcing a 
RAID6 resync. This should have created more I/O load than this box usually 
sees. 

Of course, some other combination of events might be required to cause this 
kernel crash.

I've also turned NFS back on today. Still, no problems to report.

Cheers,

Mathias




> Mike
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

