Return-Path: <linux-kernel-owner+w=401wt.eu-S1750799AbXBWCSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799AbXBWCSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 21:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbXBWCSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 21:18:17 -0500
Received: from smtp110.sbc.mail.re2.yahoo.com ([68.142.229.95]:38652 "HELO
	smtp110.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750759AbXBWCSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 21:18:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JG7W8DTylITMbpmGhfd8pGawT9oFgPCrGVYXiAkPcKf8aQUWC0PZAtqCQal0CSUxk6kGxEr0NtL0RDtZNtbXV4sQOWoOV9Mk8dAD73EtvyLtwkss5xm6JBuVqLkxxqB1fhheCxFdb44R/NiSQVQH5tamiWLP0Ux9FDtYRZdIQyU=  ;
X-YMail-OSG: XeRjfQEVM1korqaiqsYw2a489RgSh1KChALy0_j5Xt2y6TJxbo_h_KX864yTePJHGrvNRUR0G7GDFwK3_968QhwgKrngCzR_o_wke7BOgLRGGUeYYHF0E8a1gzPRP5AJX01d99v1e_AwMck-
From: David Brownell <david-b@pacbell.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: several messages
Date: Thu, 22 Feb 2007 17:15:01 -0800
User-Agent: KMail/1.7.1
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, linuxppc-dev@ozlabs.org,
       rtc-linux@googlegroups.com, Torrance <torrance123@gmail.com>
References: <200702211929.17203.david-b@pacbell.net> <200702211950.22422.david-b@pacbell.net> <Pine.LNX.4.60.0702222352460.6771@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0702222352460.6771@poirot.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702221715.03195.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 February 2007 2:58 pm, Guennadi Liakhovetski wrote:
> 
> I think, we only want 1, right? And the latter seems to be more generic / 
> platform independent? And as a side-effect, powermac would have to migrate 
> to generic rtc:-)

I'd certainly think that restoring the system clock should be, as much
as possible, in platform-agnostic code.  Like the generic RTC framework.

And hmm, that powermac/time.c file replicates other RTC code...

Minor obstacle:  removing the EXPERIMENTAL label from that code.

- Dave
