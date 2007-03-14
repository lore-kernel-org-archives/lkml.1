Return-Path: <linux-kernel-owner+w=401wt.eu-S1161204AbXCNMQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161204AbXCNMQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161198AbXCNMQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:16:14 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:3156 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161199AbXCNMQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:16:12 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE] iproute2 2.6.20-070313
Date: Wed, 14 Mar 2007 13:16:05 +0100
User-Agent: KMail/1.9.6
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       lartc@mailman.ds9a.nl
References: <20070313151549.332004c9@freekitty> <200703141223.48927.arekm@maven.pl> <45F7E527.6030307@trash.net>
In-Reply-To: <45F7E527.6030307@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703141316.05509.arekm@maven.pl>
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 of March 2007, Patrick McHardy wrote:
> Arkadiusz Miskiewicz wrote:
> > This patch
> >
> > http://www.mail-archive.com/netdev@vger.kernel.org/msg27506.html
> >
> > didn't make into upstream linux kernel it seems.
>
> As mentioned in the changelog, its in 2.6.19.

Hm, why no RTA_FWMASK in HEAD rtnetlink.h

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=include/linux/rtnetlink.h;h=4a629ea70cc4ca60a6f486f8653974af68dbe8cd;hb=HEAD

and 2.6.19

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=include/linux/rtnetlink.h;h=3a18addaed4ccb7436bffc9cf5fd0666f145d35c;hb=0215ffb08ce99e2bb59eca114a99499a4d06e704

?

> Last time I looked at the WRR patch it was a huge mess and
> used architecture dependant types in the netlink messages.
> Unless someone fixed this, adding support to iproute is a
> bad idea since in case it would get merged compatibility
> would break.
Ok.

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
