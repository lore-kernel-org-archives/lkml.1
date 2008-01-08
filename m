Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbYAHAO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbYAHAO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 19:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbYAHAOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 19:14:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39867 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154AbYAHAOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 19:14:16 -0500
Message-ID: <4782C017.3000208@zytor.com>
Date: Mon, 07 Jan 2008 16:13:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it> <9BeZN-3Gf-5@gated-at.bofh.it> <9BnTB-1As-31@gated-at.bofh.it> <9BrX4-8go-1@gated-at.bofh.it> <9BuBG-4eR-51@gated-at.bofh.it> <9BvRd-6aL-71@gated-at.bofh.it> <9GRQW-1DX-13@gated-at.bofh.it> <9GSah-23W-1@gated-at.bofh.it> <9GSDy-2GD-23@gated-at.bofh.it> <9GTpK-40d-15@gated-at.bofh.it> <9GUvy-5H2-11@gated-at.bofh.it> <9GVKU-7SS-25@gated-at.bofh.it> <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org> <478281A6.1000704@zytor.com> <alpine.LSU.0.999.0801072226060.16143@be1.lrz> <4782A355.1070207@zytor.com> <alpine.LSU.0.999.0801072316440.16143@be1.lrz> <4782AED5.1060406@keyaccess.nl> <4782B4B9.2020608@zytor.com> <4782B515.3010008@keyaccess.nl> <4782BF77.80703@reed.com>
In-Reply-To: <4782BF77.80703@reed.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> 
> And actually, if I had looked at the /sys/bus/pnp definitions, rather 
> than /proc/ioports, I would have noticed that port 80 was part of a 
> PNP0C02 resource set.   That means exactly one thing:  ACPI says that 
> port 80 is NOT free to be used, for delays or anything else.
> 
> This should make no difference here: it's just one more reason to stop 
> using port 80 for delays on modern machines.
> 

And shoot the designer of this particular microcontroller firmware.

	-hpa
