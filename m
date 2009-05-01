Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbZEALiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbZEALiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZEALiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:38:10 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:49367 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZEALiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:38:10 -0400
Message-ID: <49FADF20.9050108@msgid.tls.msk.ru>
Date: Fri, 01 May 2009 15:38:08 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> 	<20090501061701.GB19234@kroah.com> <20090430234312.a63fa5cf.akpm@linux-foundation.org> 	<20090501065527.GA19773@kroah.com> <20090501000353.b89caa8c.akpm@linux-foundation.org> <ac3eb2510905010352l661b6671je4cef88096c87878@mail.gmail.com>
In-Reply-To: <ac3eb2510905010352l661b6671je4cef88096c87878@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
[]
> It does not really change anything visible for the normal distros,
> besides that bootup can be made more efficient by running things in
> parallel, and that there will be a working and correct /dev in the
> rescue case.

Ok, how about switch_root done as the last thing in initramfs?
If there's another filesystem (besides rootfs and real /root)
mounted, what switch_root (or equivalent) should do?  Or should
the initramfs script move it (as in mount --move) to /root/dev
before invoking switch_root?

Thanks!

/mjt
