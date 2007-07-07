Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbXGGNsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbXGGNsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 09:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbXGGNsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 09:48:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:22877 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbXGGNsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 09:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H1nED+DCJYrw8nj37CX93aNYoFs0Fpg8Xd15VEYY/JFaIL0lSl97k45wILy5lU9sI9SseneR1E5Fm/+QyHjHjH31n3TEav6AOzmKQx1gk0VUIJlm+u66NTw8MYiskkK6lvVlXIsLJzYu4/7AR3+lNDBeVGjYzoVwhb4VT69B1+w=
Message-ID: <6bffcb0e0707070648v4d4af21i7c77ac931bfaaed7@mail.gmail.com>
Date: Sat, 7 Jul 2007 15:48:36 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Bob Tracy" <rct@gherkin.frus.com>
Subject: Re: 2.6.22-rc6 bad page error
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
In-Reply-To: <20070705195835.AAB19DBA1@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070705195835.AAB19DBA1@gherkin.frus.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bob,

On 05/07/07, Bob Tracy <rct@gherkin.frus.com> wrote:
> This happened on an Alpha computer (433au) running 2.6.22-rc6.

Can you reproduce this bug on 2.6.22-rc7-git6?

>  The
> error was triggered when I started up a NX KDE session, which I've
> done successfully on all occasions prior to this one.  In other words,
> I wasn't doing anything out of the ordinary...  The machine is still up
> and running as I type this, and can't/won't be rebooted for a few hours
> if there's any other troubleshooting information I need to retrieve that
> might be helpful.
>
> >Bad page state in process 'gnome-terminal'
> >page:fffffc0000a407f0 flags:0x000000000000000c mapping:0000000000000000 mapcount:1 count:1
> >Trying to fix it up, but a reboot is needed
> >Backtrace:
> >fffffc000960bc00 0000000000000000 0000000000000001 0000000000000001
> >       fffffc0000356e40 fffffc0000a407f0 fffffc0000356ee8 fffffc002399b0a0
> >       fffffc000f784a68 00000000000280d2 0000000000000000 000000012029a3c8
> >       fffffc00006fb6c0 fffffc001b0667a0 0000000000000000 0000000000000000
> >       fffffc00006fb6c8 00000000000280d2 0000000000000000 0000000000000044
> >       fffffc00006fb1f0 0000000000000000 0000000000000000 0000000000000001
> >Trace:
> >[<fffffc0000356e40>] get_page_from_freelist+0x420/0x430
> >[<fffffc0000356ee8>] __alloc_pages+0x98/0x3b0
> >[<fffffc00003638fc>] __handle_mm_fault+0x65c/0xb50
> >[<fffffc0000353554>] filemap_nopage+0x1a4/0x3d0
> >[<fffffc0000363534>] __handle_mm_fault+0x294/0xb50
> >[<fffffc000031e904>] do_page_fault+0x2d4/0x490
> >[<fffffc0000310bdc>] entMM+0x9c/0xc0
> >[<fffffc000032b0c0>] __do_softirq+0x90/0x120
> >[<fffffc000032b1b4>] do_softirq+0x64/0x70
> >[<fffffc000032b1b4>] do_softirq+0x64/0x70
> >[<fffffc0000315d94>] handle_irq+0x74/0xc0
> >
> >Bad page state in process 'syslogd'
> >page:fffffc0000a40828 flags:0x000000000000000c mapping:0000000000000000 mapcount:1 count:1
> >Trying to fix it up, but a reboot is needed
> >Backtrace:
> >fffffc002242fa98 0000000000000000 0000000000000001 0000000000000001
> >       fffffc0000356e40 fffffc0000a40828 fffffc0000356ee8 fffffc0023f6e0c0
> >       0000000000000003 00000000000000d0 0000000000000000 00000000000000d0
> >       fffffc00006fb6c0 0000000000000020 0000000000000000 0000000000000000
> >       fffffc00006fb6c8 00000000000200d0 0000000000000000 0000000000000044
> >       fffffc00006fb1f0 0000000000000000 0000000000000000 0000000000000001
> >Trace:
> >[<fffffc0000356e40>] get_page_from_freelist+0x420/0x430
> >[<fffffc0000356ee8>] __alloc_pages+0x98/0x3b0
> >[<fffffc0000375b30>] cache_alloc_refill+0x390/0x690
> >[<fffffc0000387018>] __link_path_walk+0x8a8/0x10b0
> >[<fffffc0000387374>] __link_path_walk+0xc04/0x10b0
> >[<fffffc0000375798>] kmem_cache_alloc+0x78/0x80
> >[<fffffc0000322e04>] copy_process+0xb4/0x11a0
> >[<fffffc0000323f88>] do_fork+0x98/0x330
> >[<fffffc0000323f40>] do_fork+0x50/0x330
> >[<fffffc0000313340>] alpha_clone+0x40/0x60
> >[<fffffc0000388f5c>] open_namei+0xbc/0x820
> >[<fffffc0000311480>] sys_clone+0x10/0x20
> >[<fffffc0000310f84>] entSys+0xa4/0xc0
>
> --
> -----------------------------------------------------------------------
> Bob Tracy               | "Eagles may soar, but weasels don't get
> rct@frus.com            |  sucked into jet engines."       --Anon
> -----------------------------------------------------------------------
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
