Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbYDATHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbYDATHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 15:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbYDATGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 15:06:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3612 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755768AbYDATGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 15:06:53 -0400
Date: Tue, 1 Apr 2008 15:06:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: Pavel Machek <pavel@ucw.cz>, <linux-usb@vger.kernel.org>,
       Soeren Sonnenburg <sonne@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini Core
 Duo
In-Reply-To: <20080401183732.GA5043@dose.home.local>
Message-ID: <Pine.LNX.4.44L0.0804011505050.1397-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Tino Keitel wrote:

> git-bisect revealed this:
> 
> $ git bisect good
> e82cc1288fa57857c6af8c57f3d07096d4bcd9d9 is first bad commit
> commit e82cc1288fa57857c6af8c57f3d07096d4bcd9d9
> Author: David Brownell <david-b@pacbell.net>
> Date:   Fri Mar 7 13:49:42 2008 -0800
> 
>     USB: fix ehci unlink regressions

> For the linux-usb people: this commit breaks resume from suspend to RAM
> on my Mac mini Core Duo. It worked with 2.6.24, 2.6.25-rc5, and was
> broken since 2.6.25-rc6 (also with -rc7 and later). See
> http://lkml.org/lkml/2008/3/20/23 for more information.

Can you get any information out of the computer after the hang?  It 
would help to see the dmesg log (with CONFIG_USB_DEBUG enabled) and an 
Alt-SysRq-T stack dump.

Alan Stern

