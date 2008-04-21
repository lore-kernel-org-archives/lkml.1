Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbYDUPmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbYDUPmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbYDUPmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:42:44 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37340 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755409AbYDUPmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:42:43 -0400
Subject: Re: Voyager phys_cpu_present_map compile error
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <480C8FD6.3030700@zytor.com>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi>
	 <20080421085314.GI26897@cs181133002.pp.htv.fi>
	 <20080421120054.GA6788@elte.hu>  <480C8FD6.3030700@zytor.com>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 10:42:38 -0500
Message-Id: <1208792559.3640.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 09:00 -0400, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> >> I shouldn't send bug reports at 3 in the morning...
> >>
> >> Attached is the .config for both Voyager build errors I reported.
> > 
> > thanks, the three patches below should fix it.
> > 
> > i ended up excluding Voyager configs from our test space some time ago 
> > (and VISWS as well - there's one more visws fix in x86.git), that's how 
> > this broke. These subarchitectures seem not to be used at all and the 
> > code wont boot on normal PCs. We could mark it BROKEN but the fix seems 
> > simple in any case.

I did actually try to avoid these problems by booting the -mc tree on
voyager, but I note that none of these issues showed up in that tree the
last time I did this (admittedly about 3 weeks ago because of various
conferences etc).
 
> I talked to jejb about this, and pretty much the consensus was that if 
> it breaks, mark it BROKEN, and let him come back and catch up.  Under 
> those conditions, I'm willing to keep it in the tree.

I didn't say mark it as BROKEN ... I did say I'd catch up.  However,
it's usually best to begin trying to fix voyager around the -rc1 phase
since that's when the tree becomes stable again.

> VISWS is another matter.  It's entirely possible I have the only 
> remaining VISWS in my garage; we have at least not been able to locate 
> another.  Not that we have tried all that hard.
> 
> If there are no VISWS' left, we should just unload the code.

I certainly don't have one.  I just designed the subarchitectures to be
able to support it because it was a bit far away from x86 references,
and Andrey Panin was interested in supporting it at the time ... if he's
no longer doing that, then it can be removed.

James


