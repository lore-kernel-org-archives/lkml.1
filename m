Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbXFKUx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbXFKUx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbXFKUxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:53:50 -0400
Received: from smtpa1.netcabo.pt ([212.113.174.16]:45760 "EHLO
	exch01smtp03.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752178AbXFKUxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:53:49 -0400
Message-ID: <466DB581.8050306@rncbc.org>
Date: Mon, 11 Jun 2007 21:50:09 +0100
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: 2.6.21-rt2..8 troubles
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org>	 <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu>	 <46574DE4.2080900@rncbc.org> <1180195709.4264.7.camel@chaos>	 <4658A4F4.1080204@rncbc.org>  <46660369.2070104@rncbc.org>	 <1181317625.4404.332.camel@chaos>	 <59605.213.13.107.141.1181326897.squirrel@www.rncbc.org>	 <1181328636.4404.335.camel@chaos>  <466DA42A.6010600@rncbc.org>	 <1181591122.8176.159.camel@chaos> <1181591733.11539.217.camel@imap.mvista.com>
In-Reply-To: <1181591733.11539.217.camel@imap.mvista.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2007 20:53:46.0161 (UTC) FILETIME=[9A7AFA10:01C7AC6A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Mon, 2007-06-11 at 21:45 +0200, Thomas Gleixner wrote:
>> On Mon, 2007-06-11 at 20:36 +0100, Rui Nuno Capela wrote:
>>>> I'm spinning -rt10 with a couple of fixes. Should be out sometimes
>>>> tomorrow. If the problem persists, we need to dig deeper.
>>>>
>>> Uhoh. I'm sorry to tell, but the problem is still creeping on
>>> 2.6.21.4-rt11 and -rt12 :(
>>>
>>> So sorry.
>> Hmm. Does it happen, when you boot with maxcpus=1 on the kernel
>> commandline ?
> 
> I think 2.6.21-rt2 had some apic updates also, (along with hpet updates)
> so testing with "noapic" on the command line might be helpful too .. 
>

Thomas,

Yes, "maxcpus=1" seems to keep it running, but then I render my Core2
just half-baked ;)

Daniel,

No, "noapic" does not seem to help any better.

HTH
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
