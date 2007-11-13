Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbXKMC0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbXKMC0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 21:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbXKMC0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 21:26:37 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:48217 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbXKMC0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 21:26:36 -0500
Message-ID: <47390B5B.3030306@tlinx.org>
Date: Mon, 12 Nov 2007 18:26:35 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: reboot -df "broken" in 2.6.23.1 (from 2.6.22.12)
References: <4738E36E.4090706@tlinx.org>
In-Reply-To: <4738E36E.4090706@tlinx.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

More info, the last program executed to reboot was:
"reboot -df" (in the "reboot" system script").

That should reboot w/no disk sync and no-wtmp entry (they
are done earlier in the program, explicitly).

I looked at the reboot code in the kernel for the i386
(arch/i386/kernel/reboot.c).

A new "special case" was added in 2.6.23.1 (vs. working
2.6.22.12) for a "Dell Inc.","Optiplex 745". Was that a new
machine, or was it included because of some new reboot
problem affecting the machine in 2.6.23?  If it is the latter,
maybe the problem is affecting my platform as well (Dell
Precision-690).  There is nothing looking like a Precision
workstation on the special Dell list in the reboot code.

If I include "reboot=b" on the kernel command line, reboot "works".
However, this was not needed in the previous kernel(s).
It's an easy workaround for me, but worrisome to have it
break for an unknown reason.

Anyone have any ideas?
Meanwhile, guess I'll go add reboot=b in my boot menu file. ;^/


