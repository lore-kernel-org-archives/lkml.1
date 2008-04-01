Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbYDAQ2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbYDAQ2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 12:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYDAQ2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 12:28:13 -0400
Received: from www.tglx.de ([62.245.132.106]:55427 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbYDAQ2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 12:28:12 -0400
Date: Tue, 1 Apr 2008 18:27:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chr <chunkeey@web.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with
 2.6.25-rc7
In-Reply-To: <200804010001.51288.chunkeey@web.de>
Message-ID: <alpine.LFD.1.10.0804011817310.3219@apollo.tec.linutronix.de>
References: <200803302109.22219.chunkeey@web.de> <200803302309.52493.chunkeey@web.de> <alpine.LFD.1.10.0803302315270.3219@apollo.tec.linutronix.de> <200804010001.51288.chunkeey@web.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Chr wrote:
> On Sunday 30 March 2008 23:36:40 Thomas Gleixner wrote:
> > On Sun, 30 Mar 2008, Chr wrote:
> >
> > You mentioned that you have tons of other logs. Can you please
> > upload those to some place? If you don't have a possiblity, please
> > contact me private and I'll provide you one.
> >
> Ahhm it happend again (well, actually it's the fifth time today, but this time
> I _hopefully_ found something)
> 
> I made a new log: (check out bugzilla)
> http://bugzilla.kernel.org/show_bug.cgi?id=10369
> 
> (direct link)
> http://bugzilla.kernel.org/attachment.cgi?id=15542
 
# expires at 4839289000000 nsecs [in -168780949682 nsecs]

That's strange. Local APIC timer interrupt seems to be stuck.

Can you please upload a boot log and the output of
/proc/timer_list of 2.6.24.x to the bugzilla ?

Does adding "noapictimer" to the command line help ?

Thanks,

	tglx
