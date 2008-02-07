Return-Path: <linux-kernel-owner+w=401wt.eu-S933757AbYBGWrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757AbYBGWrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760239AbYBGWrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:47:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36992 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbYBGWrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:47:03 -0500
Message-ID: <47AB8A41.3040008@zytor.com>
Date: Thu, 07 Feb 2008 14:46:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <200802060227.14385.rjw@sisk.pl> <200802070049.00461.rjw@sisk.pl> <200802072312.31430.rjw@sisk.pl> <20080207222845.GA6096@elf.ucw.cz>
In-Reply-To: <20080207222845.GA6096@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> This is probably more acceptable version of beep; but there are
> probably even better ways to clean it...
> 
>         if (wakeup_header.realmode_flags & 4) {
>                 inb(97);
>                 outb(0, 0x80);
>                 outb(3, 97);
>                 outb(0, 0x80);
>                 outb(-74, 67);
>                 outb(0, 0x80);
>                 outb(-119, 66);
>                 outb(0, 0x80);
>                 outb(15, 66);
>         }
> 

What is available at this point -- are BIOS calls still accessible; are 
interrupts running?

	-hpa
