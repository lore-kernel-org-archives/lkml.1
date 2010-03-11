Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0CKNQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:16:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:59527 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236Ab0CKNQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:16:47 -0500
Date: Thu, 11 Mar 2010 14:16:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Ole Reier Ulland <ole.reier@netcom.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ZTE MF636 USB modem is not supported
In-Reply-To: <201003110008.58644.ole.reier@netcom.no>
Message-ID: <alpine.LRH.2.00.1003111415230.12517@twin.jikos.cz>
References: <201003110008.58644.ole.reier@netcom.no>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010, Ole Reier Ulland wrote:

> I have reported this a while ago to the Mandriva bugzilla, but I cannot see if 
> anyone is doing anything about it. So now I just want to send the link to this 
> e-mail address to get a reply and some understanding.
> 
> https://qa.mandriva.com/show_bug.cgi?id=57165
> 
> [root@Dell_Dim Mine_Filer_1_FAT]# uname -a
> Linux Dell_Dim 2.6.31.12-desktop-1mnb #1 SMP Tue Jan 26 03:35:36 EST 2010 i686 
> Intel(R) Pentium(R) 4 CPU 2.80GHz GNU/Linux
> 
> Is it fixed already maybe? Is there another kernel that I can use?
> 
> Is there anything else I can do to help this along?

It is likely that your modem will need to have been switched to "serial" 
mode over from the default "storage" mode before it could be used 
(usb_modemswitch is an userspace application to do that for many ZTE 
modems).

Could you please post

1) dmesg once your modem is plugged in
2) lsusb -v output for this modem

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

