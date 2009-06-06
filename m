Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbZFFW17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbZFFW17 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZFFW1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:27:51 -0400
Received: from smtp2.netcologne.de ([194.8.194.112]:33738 "EHLO
	smtp2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZFFW1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:27:49 -0400
X-Greylist: delayed 1663 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Jun 2009 18:27:49 EDT
From: Mathias Kretschmer <mathias@blx4.net>
Organization: BLX4
To: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Sun, 7 Jun 2009 00:00:48 +0200
User-Agent: KMail/1.9.9
Cc: Mathias Kretschmer <posting@blx4.net>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Alex Samad <alex@samad.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera> <200906061011.34124.posting@blx4.net> <alpine.DEB.1.10.0906061138150.9860@router.windsormachine.com>
In-Reply-To: <alpine.DEB.1.10.0906061138150.9860@router.windsormachine.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906070000.48960.mathias@blx4.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 June 2009 17:38:44 Mike Dresser wrote:
> On Sat, 6 Jun 2009, Mathias Kretschmer wrote:
> > Is your machine still happy ?
> >
> > If so, I'll give 2.6.30-rc8 a shot, as well.
>
> Still running, no crashes or errors so far

OK. running 2.6.30-rc8-git2.  no crashes, so far.

but, same problem as with 2.6.29: tons of 'reconnect_path: npd != pd" messages 
and stale NFS handles on the client boxes (i.e. my desktop).

I upgraded from 2.6.25, which worked fine.

The box is an AMD K8 (x86_64) with sata,raid6,lvm,xfs,nfsd.

Mathias


> Mike
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
