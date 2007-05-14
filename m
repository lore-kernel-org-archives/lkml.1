Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbXENTVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbXENTVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbXENTVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:21:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbXENTVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:21:34 -0400
Date: Mon, 14 May 2007 15:21:30 -0400
From: Dave Jones <davej@redhat.com>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: tracking down disk spinups.
Message-ID: <20070514192130.GN27604@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Xavier Bestel <xavier.bestel@free.fr>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070514185734.GM27604@redhat.com> <1179169385.2397.2.camel@bip.parateam.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1179169385.2397.2.camel@bip.parateam.prv>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 09:03:05PM +0200, Xavier Bestel wrote:
 > Le lundi 14 mai 2007 à 14:57 -0400, Dave Jones a écrit :
 > 
 > > (14:49:52:root@firewall:~)# mount
 > > /dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
 > > (14:49:56:root@firewall:~)# mount /dev/mapper/VolGroup00-LogVol00 / -t ext2 -o remount,rw
 > > (14:50:37:root@firewall:~)# mount
 > > /dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
 > > 
 > > Why did the kernel ignore what I told it to do ?
 > > I'm sure it thinks it knows better than me for a reason, but
 > > I'd like to know what it is.
 > 
 > Are you sure it's the kernel, and not just mount ?
 > Did you try cat /proc/mounts ?

Yes.  It's further evidenced that it's ext3 by the fact
that kjournald still shows up in the logs.
Not a single line gets printed to dmesg.

	Dave

-- 
http://www.codemonkey.org.uk
