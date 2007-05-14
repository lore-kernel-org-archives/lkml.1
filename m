Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbXENTZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbXENTZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXENTZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:25:00 -0400
Received: from gw.goop.org ([64.81.55.164]:44262 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbXENTY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:24:59 -0400
Message-ID: <4648B789.7080905@goop.org>
Date: Mon, 14 May 2007 12:24:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: tracking down disk spinups.
References: <20070514185734.GM27604@redhat.com>
In-Reply-To: <20070514185734.GM27604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> (14:49:52:root@firewall:~)# mount
> /dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
> (14:49:56:root@firewall:~)# mount /dev/mapper/VolGroup00-LogVol00 / -t ext2 -o remount,rw
> (14:50:37:root@firewall:~)# mount
> /dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
>
> Why did the kernel ignore what I told it to do ?
> I'm sure it thinks it knows better than me for a reason, but
> I'd like to know what it is.
>   

I don't think you can change filesystem types with remount.  Doesn't
that just change flags on an existing mount?

    J

