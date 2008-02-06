Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbYBFBhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbYBFBhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 20:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbYBFBhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 20:37:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52160 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbYBFBhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 20:37:09 -0500
Message-ID: <47A90F23.80009@zytor.com>
Date: Tue, 05 Feb 2008 17:36:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <200802060227.14385.rjw@sisk.pl>
In-Reply-To: <200802060227.14385.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, 5 of February 2008, Pavel Machek wrote:
>> This rewrites wakeup code to .c, and it fixes stack (should use movl
>> ,%esp, not movw). Testers wanted. Makefile infrastructure was done by
>> hpa, cleanups by rjw.
> 
> I'll test it tomorrow and I still have some more cleanups (I was distracted by
> a nasty scheduler issue in the current mainline).

The asm() for making beeps really need to be moved to a function and 
cleaned up (redone in C using inb()/outb()) if they are to be retained 
at all.

	-hpa
