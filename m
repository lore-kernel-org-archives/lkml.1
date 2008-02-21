Return-Path: <linux-kernel-owner+w=401wt.eu-S935596AbYBUWp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935596AbYBUWp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934980AbYBUWpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:45:20 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:58369 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934720AbYBUWpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:45:18 -0500
Message-ID: <47BDFE2C.208@cfl.rr.com>
Date: Thu, 21 Feb 2008 17:41:48 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mark Hounschell <markh@compro.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: 2.6.24-rt1 IRQ routing anomaly
References: <47BD6802.60604@cfl.rr.com> <Pine.LNX.4.58.0802210743080.9890@gandalf.stny.rr.com> <47BD7D09.9050106@compro.net> <Pine.LNX.4.58.0802211005380.9890@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0802211005380.9890@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 21 Feb 2008, Mark Hounschell wrote:
>>> To prove this is the problem, boot with noapic in the kernel command line.
>>> 1) the problem should disappear.
>>> 2) (I'm betting) you see that the eth and EMU10K1 share the same
>>>    interrupt line.
>>>
>> Yep, you were right. They do share the same IRQ and the problem does go away.
>> Unfortunately  I can't run this machine with noapic. I need irq affinity.
>>
> 
> Thanks for verifying. OK, I'll see if I can get the workaround on i386. I
> thought I saw a patch someplace where someone ported that workaround. I'm
> still sorting out bugs in -rt2 (why it is still not out). I'll see if I
> can find time to get the workaround to i386 for -rt2 as well.
> 
> -- Steve

I'll be happy to test it for ya

Mark

