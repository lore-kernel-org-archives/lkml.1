Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYCaWCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYCaWCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYCaWBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:01:54 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:35713 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbYCaWBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:01:54 -0400
From: Chr <chunkeey@web.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Tue, 1 Apr 2008 00:01:50 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <200803302109.22219.chunkeey@web.de> <200803302309.52493.chunkeey@web.de> <alpine.LFD.1.10.0803302315270.3219@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0803302315270.3219@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804010001.51288.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1/R2SBfxyaXOAccZ7D9V1bx927jRmEBv1p6tC+x
	sDEhpkPXmFm3IHpct3EWMckmewoCTYwZnJjTjwxm8dtoDcBUHo
	hi0L7KDLc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 March 2008 23:36:40 Thomas Gleixner wrote:
> On Sun, 30 Mar 2008, Chr wrote:
>
> You mentioned that you have tons of other logs. Can you please
> upload those to some place? If you don't have a possiblity, please
> contact me private and I'll provide you one.
>
Ahhm it happend again (well, actually it's the fifth time today, but this time
I _hopefully_ found something)

I made a new log: (check out bugzilla)
http://bugzilla.kernel.org/show_bug.cgi?id=10369

(direct link)
http://bugzilla.kernel.org/attachment.cgi?id=15542

so, this log was made from a _working_ machine over the serial
console... I put some _real_ "date" marks here and there... 
to explain a bit, how the time STALLS... (well, it seems like
it goes a bit backward and forward and backwards again...  it loops?!
whatever..!??!?!!)

just take a look at the jiffies (grep for them... it takes "minutes"
until jiffies+1 comes)

Maybe there's a "signed" problem somewhere in the timekeeping
code? Or does 2.6.25-rcX have a general problem with NTP-daemons
like chrony?

Regards,
	Chr.
