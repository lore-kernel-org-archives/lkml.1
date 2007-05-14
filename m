Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbXENTDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbXENTDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXENTDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:03:11 -0400
Received: from smtp21.orange.fr ([80.12.242.47]:4082 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXENTDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:03:10 -0400
X-ME-UUID: 20070514190307929.E301E1C000A3@mwinf2107.orange.fr
Subject: Re: tracking down disk spinups.
From: Xavier Bestel <xavier.bestel@free.fr>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070514185734.GM27604@redhat.com>
References: <20070514185734.GM27604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Mon, 14 May 2007 21:03:05 +0200
Message-Id: <1179169385.2397.2.camel@bip.parateam.prv>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 14 mai 2007 à 14:57 -0400, Dave Jones a écrit :

> (14:49:52:root@firewall:~)# mount
> /dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
> (14:49:56:root@firewall:~)# mount /dev/mapper/VolGroup00-LogVol00 / -t ext2 -o remount,rw
> (14:50:37:root@firewall:~)# mount
> /dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
> 
> Why did the kernel ignore what I told it to do ?
> I'm sure it thinks it knows better than me for a reason, but
> I'd like to know what it is.

Are you sure it's the kernel, and not just mount ?
Did you try cat /proc/mounts ?

	Xav


