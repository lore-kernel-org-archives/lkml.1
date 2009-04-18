Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbZDRQFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbZDRQFg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 12:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZDRQF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 12:05:26 -0400
Received: from outbound-mail-110.bluehost.com ([69.89.22.10]:41288 "HELO
	outbound-mail-110.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752828AbZDRQFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 12:05:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=GgiE0ofi7+Xw82JtWRhmOsJM9FcaFnwwmSrCWdxAE2OsAA/YQ5tn9rd7gQby+97pALsxyV66NHPNbqQt32TctOUpNzmZAat28043ZkLQLWRQE4GUb9e6yFjsxsIRPkH4;
Date: Sat, 18 Apr 2009 09:05:21 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] pci: keep pci device resource name pointer right.
Message-ID: <20090418090521.6b2d1d26@hobbes>
In-Reply-To: <20090418075130.GK7678@elte.hu>
References: <20090416165640.GA13927@elte.hu>
	<49E76864.9060309@kernel.org>
	<20090416172803.GB16618@elte.hu>
	<49E7916C.7050701@kernel.org>
	<alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>
	<20090416235452.GE21405@elte.hu>
	<alpine.LFD.2.00.0904161716270.4042@localhost.localdomain>
	<20090417131633.GA30578@elte.hu>
	<49E8FD0B.2050308@zytor.com>
	<49E96731.1000501@kernel.org>
	<20090418075130.GK7678@elte.hu>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009 09:51:30 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > Impact: fix bug
> 
> i think this needs to be marked Cc: <stable@kernel.org> as well, for 
> 2.6.29.x, maybe even 2.6.28.x ?
> 
> ( Please note a small commit log detail: a few days go we started 
>   putting impact lines to the end of the commit as 'footers', in 
>   square brackets - right before the signoff lines. We do this to 
>   move them closer to other mechanic-looking tags and to not intrude 
>   the flow of the natural-language story line of the commit.
> 
>   Also note that 'fix bug' is not a good impact line even if it was 
>   a footer, because it does not really summarize the effects of a 
>   patch specifically enough. A better variant would be:
> 
>      [ Impact: fix corrupted names in /proc/iomem ]
> 
>   I've inserted this impact line into your commit below, to show the 
>   exact placement we started using. Note, this impact line would 
>   also be a perfect summary line, if the 'pci: ' tag is added before 
>   it:
> 
>      pci: fix corrupted names in /proc/iomem
> 
>   Jesse or Linus might opt to remove the impact line - it's a per 
>   subsystem discretion thing. )

Yeah I noticed the x86 patches seem to have those "Impact" lines these
days, but I couldn't figure out what they meant.  Sometimes they
indicate the symptom being addressed, other times they act as a sort of
summary subject.  What's the intention?  Is it really "user
visible impact"?  Or something else?  Patch subjects generally suffer
from similar ambiguity (sometimes describing what the patch is doing to
the code, other times what issue the patch is addressing), so it would
be nice if "Impact" was something separate and well defined.

-- 
Jesse Barnes, Intel Open Source Technology Center
