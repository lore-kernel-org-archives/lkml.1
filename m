Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYIYOKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYIYOKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYIYOKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:10:04 -0400
Received: from sandeen.net ([209.173.210.139]:27374 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYIYOKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:10:03 -0400
X-Greylist: delayed 1281 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2008 10:10:03 EDT
Message-ID: <48DB96B8.6050503@sandeen.net>
Date: Thu, 25 Sep 2008 08:48:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.27-rc7 no init found on the root partition?
References: <20080924192227.GC31582@ics.muni.cz> <20080924230326.GM5448@disturbed> <20080925111239.GF31582@ics.muni.cz>
In-Reply-To: <20080925111239.GF31582@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:

> this is a grub record:
> 
> title Linux 2.6.26.3
> root (hd0,0)
> kernel /boot/vmlinuz-2.6.26.3 root=/dev/sda1 ro console=tty0
> 
> title Linux 2.6.27-rc7
> root (hd0,0)
> kernel /boot/vmlinuz-2.6.27-rc7 root=/dev/sda1 ro 

Is it possible that device ordering has changed?  what if you do:

> title Linux 2.6.27-rc7
> root (hd0,0)
> kernel /boot/vmlinuz-2.6.27-rc7 root=LABEL=$WHATEVER ro

and try mounting root by label? (or UUID ...)

-Eric

