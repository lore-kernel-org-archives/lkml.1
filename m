Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab0CIWbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:31:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51104 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752639Ab0CIWbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 17:31:06 -0500
Date: Tue, 9 Mar 2010 17:31:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Markus Rechberger <mrechberger@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: USBFS Memory allocation Bug
In-Reply-To: <d9def9db1003091309p3aa84879lb586cb0406f62693@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1003091729320.1693-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010, Markus Rechberger wrote:

> Hi,
> 
> I just stumbled around following issue:
> 
> [275835.163502] Pid: 14298, comm: mediasrv Not tainted 2.6.33 #7
> [275835.163505] Call Trace:
> [275835.163514]  [<ffffffff810df7a6>] __alloc_pages_nodemask+0x5b6/0x700
> [275835.163520]  [<ffffffff8110c667>] alloc_pages_current+0x87/0xd0
> [275835.163525]  [<ffffffff810dcf79>] __get_free_pages+0x9/0x50
> [275835.163529]  [<ffffffff81114f2b>] __kmalloc+0x13b/0x1f0
> [275835.163535]  [<ffffffff813a18ef>] proc_do_submiturb+0x2ff/0x9d0
> [275835.163539]  [<ffffffff813a26b9>] usbdev_do_ioctl+0x6f9/0x14a0

The mediasrv program tried to allocate more memory than was available.  
It's unfortunate but it's not a bug.

Alan Stern

