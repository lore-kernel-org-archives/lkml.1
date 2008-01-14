Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbYANWUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbYANWUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbYANWQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:16:46 -0500
Received: from mail001.aei.ca ([206.123.6.130]:34823 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464AbYANWQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:43 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Date: Mon, 14 Jan 2008 17:16:36 -0500
User-Agent: KMail/1.9.7
Cc: Matthew <jackdachef@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <47841C41.4060401@zytor.com> <e85b9d30801140847k4b19cea4nd08461c1664a1b35@mail.gmail.com> <20080114170036.GL15542@elte.hu>
In-Reply-To: <20080114170036.GL15542@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801141716.38380.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On January 14, 2008, Ingo Molnar wrote:
> 
> * Matthew <jackdachef@gmail.com> wrote:
> 
> > > FYI, latest x86.git should have this fix included. So if your box 
> > > still hangs there must be some other bug lurking as well.
> > 
> > 
> > the fix from Roland ?: http://lkml.org/lkml/2008/1/11/108
> > http://forums.gentoo.org/viewtopic-p-4719206.html#4719206 (+ following posts)
> > 
> > works like a charm :)
> > wine-problems should be solved,
> > 
> > 64bit firefox & 32bit flash, 32bit firefox, 32bit thunderbird, 
> > realplayer work fine again without hardlocking so far (at least for 
> > me)
> 
> great - thanks for following through with this, this was an important 
> regression to get fixed! I've added:
> 
> Tested-by: Matthew <jackdachef@gmail.com>

Ingo,

This is _not_ a regression.  This has been occuring for ages here.  A backport of this fix to 2.6.23 would be a 
very good thing - IMHO its something that should go into stable asap.

Thanks,
Ed Tomlinson


