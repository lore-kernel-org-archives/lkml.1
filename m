Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYJNCUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYJNCUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 22:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbYJNCTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 22:19:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:58768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbYJNCTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 22:19:51 -0400
Message-ID: <48F40164.5000502@kernel.org>
Date: Tue, 14 Oct 2008 11:18:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
CC: Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SMART to USB/sata dock in 2.6.27-rc5 doesn't work
References: <48EE7E0A.8040701@dgreaves.com>
In-Reply-To: <48EE7E0A.8040701@dgreaves.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Oct 2008 02:19:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
> I just bought a usb/sata adapter like this:
>   http://www.thinkgeek.com/computing/drives/a7ea/?cpg=ab
> lsusb -v is below
> 
> Works OK as a hot-plug SATA disk so I can check what's on that old disk in the
> corner; but smartctl doesn't work so I can't see if it has any errors, run
> selftests etc.
> 
> Kernel is 2.6.27-rc5 (I've also tried older kernels)
> 
> I plugged a previously zeroed drive in and...
> 
> root@ash:~ # smartctl -a /dev/sde
> smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> Device: ST332062 0AS              Version:
> Device type: disk
> Local Time is: Thu Oct  9 21:38:16 2008 BST
> Device supports SMART and is Enabled
> Temperature Warning Disabled or Not Supported
> SMART Health Status: OK
> 
> Error Counter logging not supported
> Device does not support Self Test logging

The USB bridge should support SAT (SCSI-ATA translation) and many
don't.  Nothing much can be done about it.  The hardware just don't know
how to do it.

-- 
tejun
