Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbYBFLNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbYBFLNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYBFLNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:13:34 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:64693 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbYBFLNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:13:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TogJWn3yG6mSEoMHXpHiiLqz1wP75ifdS5lHEpKdv9zaG4Rmw82yuuqCEbLyFapdf9BeUDLT/U8PeHfFk7Pihm4wcwMIsuQNGMe24Wr4f2POHgszyxkkDfqHyK3nBcncYsQoD71sKk+dV305lwK0py6LlWRP3559pnJs3gv+gJc=
Message-ID: <2f11576a0802060313k3f17547ev4d2643c3a130f59f@mail.gmail.com>
Date: Wed, 6 Feb 2008 20:13:29 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.24-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080203171634.58ab668b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
X-Google-Sender-Auth: 26b774df83f60fc6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/
>
>
> - The x86 git tree has been dropped due to runtime failure on one of my test
>   machines

My PC display warning message at boot time.
Could I help your debugging?

----------------------------------------------------------------------------------------------

end_request: I/O error, dev fd0, sector 0
                Welcome to  CentOS release 5 (Final)
                Press 'I' to enter interactive startup.
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2037 _spin_unlock_irq+0x20/0x23()
Modules linked in: usb_storage ahci ata_piix libata ehci_hcd ohci_hcd uhci_hcd
Pid: 1085, comm: hwclock Not tainted 2.6.24-mm1 #1
 [<c011e75f>] warn_on_slowpath+0x40/0x4f
 [<c012cc1b>] __kernel_text_address+0x18/0x23
 [<c0105710>] dump_trace+0xb3/0xbd
 [<c0137bd1>] check_usage_forwards+0x16/0x35
 [<c0137d5d>] mark_lock+0x16d/0x389
 [<c03ed8f2>] _spin_unlock_irq+0x20/0x23
 [<c0114675>] hpet_rtc_interrupt+0xe6/0x2a7
 [<c014582b>] handle_IRQ_event+0x13/0x3d
 [<c01466d6>] handle_edge_irq+0xc2/0xff
 [<c010664a>] do_IRQ+0x6e/0x84
 [<c010516e>] common_interrupt+0x2e/0x34
 [<c03e007b>] nv_probe+0x1281/0x13bc
 [<c03ef010>] do_page_fault+0x15f/0x4ae
 [<c03eeeb1>] do_page_fault+0x0/0x4ae
 [<c03edb62>] error_code+0x72/0x78
 =======================
---[ end trace 908d580e4399e39b ]---
