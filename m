Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYHSQLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYHSQLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYHSQLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:11:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54670 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYHSQLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:11:35 -0400
Message-ID: <48AAEFBE.5060406@zytor.com>
Date: Tue, 19 Aug 2008 09:07:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Fries <david@fries.net>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] i486 CR4 oops, no_console_suspend
References: <20080818040340.GB17528@spacedout.fries.net> <20080818064120.GA28941@elte.hu> <20080819033710.GD17528@spacedout.fries.net> <20080819093454.GG28713@elte.hu>
In-Reply-To: <20080819093454.GG28713@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> i've had trouble no end with getting even kernel messages out to the 
> serial console during critical phases of suspend/resume. (especially in 
> combination with earlyprintk=ttyS0 - not surprisingly)
> 
> Especially during resume the UART is initialized back to something 
> really slow - 300 bauds or 9600 bauds. (depends on the chipset i guess) 
> So even though it works, it will only worked reliably when i 
> standardized all my baud settings to that very low setting.
> 

Probably depends on the BIOS, actually; I suspect you end up with the 
standard BIOS setting, which is *usually* 9600 bps.

	-hpa
