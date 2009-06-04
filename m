Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbZFDR2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbZFDR2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZFDR2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:28:34 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:56703 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZFDR2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:28:33 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 12:27:07 -0500
User-Agent: KMail/1.9.9
Cc: Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906040948480.4880@localhost.localdomain> <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041227.10529.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, Linus Torvalds wrote:
> 
> Side note: is it more stable if you disable the VIA speedstep thing 
> (whatever it's called (ok, google tells me it's called "TwinTurbo" and 
> "Advanced PowerSaver")?
>

The e_powersave code.
Yes, I build test cases with and without - -
It was a fixed-speed kernel build that first hit the 4 hour up-time mark.
I just reposted that build today (the -09143lk).

 
> Features like that easily put a huge stress on power regulators etc, if 
> they result in sudden changes in current draw.  Underspecced capacitors 
> etc can cause CPU "brown-outs", which in turn can easily cause total 
> failure. 
>

There is also a possible thermal issue with these machines - -
I doubt that VIA runs their qualification testing in bake ovens;
which is what NetBook cases amount too.  ;)

Before the week's end - I am going to run a few of these test builds
with the machine in the freezer - a 20C decrease in ambient should
show if there is any thermal relationship with the problem.

I just need to run my lan into the freezer compartment - one of the
places in this house without a lan connection.  ;)

For want of a documented JTAG port...

Mike
> 
> 		Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


