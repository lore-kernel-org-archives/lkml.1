Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYHROFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYHROFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYHROFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:05:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:52502 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbYHROFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:05:03 -0400
Message-ID: <48A98193.2010606@windriver.com>
Date: Mon, 18 Aug 2008 09:05:07 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: amruth_pv@yahoo.com
CC: linux-kernel@vger.kernel.org
Subject: Re: KGDB 2..26 fails to wait while booting
References: <903878.21411.qm@web45204.mail.sp1.yahoo.com>
In-Reply-To: <903878.21411.qm@web45204.mail.sp1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Aug 2008 14:05:02.0047 (UTC) FILETIME=[683FA6F0:01C9013B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amruth wrote:
> Hi
> I have created 2.6.26 kernel with KGDB enabled but the system fails to
wait. Can anybody provide me detailed info on how to setup the grub
configuration to wait until gdb connects from development machine.
> Thanks
> Amruth p.v
>
>
>      
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

What parameters did you use in grub?

Generally speaking you have to setup the boot parameters to be something
like:

kgdboc=ttyS0,115200 kgdbwait

Jason.

