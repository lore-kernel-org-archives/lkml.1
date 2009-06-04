Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbZFDWA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbZFDWA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 18:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZFDWAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 18:00:19 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:60814 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZFDWAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 18:00:18 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Dave Jones <davej@redhat.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 17:00:15 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041638.15480.lkml@morethan.org> <20090604214301.GB20822@redhat.com>
In-Reply-To: <20090604214301.GB20822@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041700.17852.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, Dave Jones wrote:
> On Thu, Jun 04, 2009 at 04:38:13PM -0500, Michael S. Zick wrote:
>  > I have already preceded that chunk of code with a printk and confirmed
>  > that x86_clflush_size is properly set to 64 bytes (somewhere else).
>  > 
>  > So your suggestion is the obvious one for the C7-M,
>  > I don't know about any other makes/models. 
>  > 
>  > This machine's C7-M is being reported as a "stepping 0" ??
>  > What is earlier than a stepping 0 ??
> 
> Earlier model numbers.
> (Stepping gets reset to 0 every time they bump the model)
> 

So 6.model=13.stepping=0 should do it for the (or this) C7-M, correct?
Your mention of "earlier models" will not apply until there is a
stepping >0 for a model=13, correct?

Would a good practice be to put a "WARN_ON" in there in case a stepping
greater than =0 happens to execute the code?
In addition to checking specificly for 6.13.0 (rather than just 6.13).

Hmmm...
But that is making a big mess of a small mess -
Why not just do the assignment you suggest for 6.model>=13?

Models earlier than 13 are evidently working (due to lack of
bug reports or other noise on this list).

Mike
> 	Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


