Return-Path: <linux-kernel-owner+w=401wt.eu-S1757810AbYEEKEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810AbYEEKEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYEEKD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:03:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:24741 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYEEKDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from:sender;
        b=KqTGlbRE+Gd57KKh4p1PopbTkJAT60e2OYR8dNW0HLV8fL6gI9/Ihfhlnx5/CIeERahk1Tt78sHoDHC720SHxuGNevejVrQuM+ypFusIaVRQSP8r0Ac12S+Ol9Tky4D5ZAGNDOgwc/ZPaoJUNL7+DUi4sb4AHJRY4RQk2IkkI2I=
Message-ID: <481EDB7F.3050200@gmail.com>
Date: Mon, 05 May 2008 13:03:43 +0300
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
References: <20080429.190352.137408408.davem@davemloft.net>	 <200804302136.58005.rjw@sisk.pl>	 <20080430131537.1f7a0914.akpm@linux-foundation.org>	 <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>	 <20080501003125.GM29330@cs181133002.pp.htv.fi>	 <20080430000338.50548884@infradead.org>	 <20080501011346.522f9846.akpm@linux-foundation.org>	 <20080430071526.1bce202c@infradead.org> <1209645764.25560.547.camel@pmac.infradead.org>
In-Reply-To: <1209645764.25560.547.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Benny Halevy <bhalevy@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May. 01, 2008, 15:42 +0300, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2008-04-30 at 07:15 -0700, Arjan van de Ven wrote:
>> Maybe that's a "boggle" for you; but for me that's symptomatic of
>> where we are today: We don't make (effective) prioritization
>> decisions. Such decisions are hard, because it effectively means
>> telling people "I'm sorry but your bug is not yet important". 
> 
> It's not that clear-cut, either. Something which manifests itself as a
> build failure or an immediate test failure on m68k alone, might actually
> turn out to cause subtle data corruption on other platforms.
> 
> You can't always know that it isn't important, just because it only
> shows up in some esoteric circumstances. You only really know how
> important it was _after_ you've fixed it.
> 
> That obviously doesn't help us to prioritise.
> 

Ideally, you'd do an analysis first and then prioritize, based
on the severity of the bug, its exposure, how easy it is it fix,
etc.  If while doing that you already have a fix at hand, you're
almost done :)

Recursively, there's the problem of which bugs you analyze first.
I'm inclined to say that you want to analyze most if not all bug reports
in higher priority than working on fixing non-critical bug.

Benny
