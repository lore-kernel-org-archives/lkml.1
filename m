Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbXLKAcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbXLKAcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 19:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbXLKAcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 19:32:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56840 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXLKAb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 19:31:59 -0500
Message-ID: <475DDA4C.9020002@zytor.com>
Date: Mon, 10 Dec 2007 16:31:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: "David P. Reed" <dpreed@reed.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <47595DB2.5080302@reed.com> <20071207145430.GA5992@one.firstfloor.org> <47596A2E.4060602@keyaccess.nl> <4759749E.5070401@keyaccess.nl>
In-Reply-To: <4759749E.5070401@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> 
> By the way, David, it would be interesting if you could test 0xed. If 
> your problem is some piece of hardware getting upset at LPC bus aborts 
> it's not going to matter and we'd know an outb delay is just not an 
> option on your system at least. You said you could quickly reproduce the 
> problem with port 0x80?
> 

I tried 0xED for a few versions (1.31-1.37) of SYSLINUX.  It broke on a 
lot of hardware (Phoenix BIOS uses 0xED by default, but BIOSes don't 
have to work on arbitrary hardware.)

	-hpa
