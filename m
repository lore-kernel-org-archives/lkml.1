Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZFHHg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZFHHg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZFHHgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:36:03 -0400
Received: from relay01-haj2.antispameurope.com ([83.246.65.51]:51866 "EHLO
	relay01-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823AbZFHHgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:36:01 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2009 03:36:00 EDT
From: Mathias Kretschmer <posting@blx4.net>
Organization: BLX4
To: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Mon, 8 Jun 2009 09:27:09 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.28-11-generic; KDE/4.2.3; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Samad <alex@samad.com.au>, Dave Chinner <david@fromorbit.com>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <AN6kEAA5GQ.A.WDB.xj7KKB@chimera> <alpine.DEB.1.10.0906071608010.3914@router.windsormachine.com>
In-Reply-To: <alpine.DEB.1.10.0906071608010.3914@router.windsormachine.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906080927.10479.posting@blx4.net>
X-OriginalArrivalTime: 08 Jun 2009 07:27:11.0314 (UTC) FILETIME=[89A15B20:01C9E80A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009 22:09:23 Mike Dresser wrote:
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
>
> Still testing, but so far 2.6.30-rc8(or another RC) seems to have fixed
> this.  I'd say to leave this open for now, there's at least one other
> person testing 2.6.30-rc8 to see if it's fixed or not.

I'm afraid my test here won't help much to answer this question.

I've seen no more crashes, but starting with 2.6.29 I'm seeing so many 
'reconnect_path: npd != pd' messages and am experiencing lots of 'stale NFS 
handles'  that I turned off NFS yesterday evening until I have more time to look 
into this.

-Mathias


> Mike
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

