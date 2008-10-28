Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYJ1SPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYJ1SPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYJ1SPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:15:07 -0400
Received: from mail-gx0-f18.google.com ([209.85.217.18]:48998 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYJ1SPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:15:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RoYnq6VqLIqgzWfWlc4HQi6OibD5UTp2JUGuXu+LlLMhDlkNra1WEgEdZrTRWXrKlV
         BY9Cj+l3r+S37Rx8dDOFpgI2L7ZKOg12lKX0tipUyReBLEvVKRPrSZShOhHzhvGFTmLu
         0nWDCdY5CD2GrQRCg+xDPDHoccH3V9o3G/m5k=
Date: Tue, 28 Oct 2008 21:14:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix init_memory_mapping for [dc000000 - e0000000)
Message-ID: <20081028181459.GC7357@localhost>
References: <490406FD.30604@kernel.org> <20081027165028.GB30573@linux-os.sc.intel.com> <20081027175547.GE3046@elte.hu> <49067058.7010106@kernel.org> <20081028092737.GT15734@elte.hu> <20081028174813.GB7357@localhost> <20081028181004.GA11275@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028181004.GA11275@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Oct 28, 2008 at 07:10:04PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Ingo Molnar - Tue, Oct 28, 2008 at 10:27:37AM +0100]
| > | 
| > | * Yinghai Lu <yinghai@kernel.org> wrote:
| > | 
| > | > Impact: fix range calculation
| > | 
| > | applied to tip/x86/urgent, thanks Yinghai!
| > | 
| > | i changed the impact line to:
| > | 
| > | Impact: change over-mapping to precise mapping, fix /proc/meminfo output
| > | 
| > | 	Ingo
| > | 
| > 
| > When we started to use Impact: line? I mean -- now we have
| > to use it? Just noticed this word in patches a day or maybe
| > several day ago -- so it seem to be quite freshy :)
| 
| We've been experimenting with the impact-line for a couple of 
| weeks/months, just to see how it works out in practice.
| 
| The first impact-line ever was added by hpa in mid-summer:
| 
| | commit 908ec7afacfdc83dc10938ed1d3c38b3526034ec
| | Author: H. Peter Anvin <hpa@zytor.com>
| | Date:   Mon Jun 30 14:42:18 2008 -0700
| |
| |    x86: remove arbitrary ELF section limit in i386 relocatable kernel
| |    
| |    Impact: build failure in maximal configurations
| 
| The concept seems to be quite good in general:
| 
|  - increases the readability of the changlogs
| 
|  - makes it easier to judge the backporting needs of a commit, even 
|    if a commit has not been marked as Cc: <stable@kernel.org> straight 
|    away.
| 
|  - makes it easier to notice bugs in a commit: when a commit marked as 
|    "Impact: cleanup" causes some behavioral change it's clear that 
|    it's buggy.
| 
| It basically acts as a second-level subject line.
| 
| So, given these many advantages, we now try to extend the use of 
| impact-lines to all the tip/*/urgent branches.
| 
| It's not a must-have item for patch submissions, just a nice-to-have 
| property. (we'll add the impact-line when it's missing)
| 
| 	Ingo
| 

Ingo, I think it's a subject for SubmittingPatches then. To
eliminate future possible questions for those who never saw it
before. Thanks for explanation!

		- Cyrill -
