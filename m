Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbXDUACN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbXDUACN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 20:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXDUACN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 20:02:13 -0400
Received: from gw.goop.org ([64.81.55.164]:33576 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbXDUACL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 20:02:11 -0400
Message-ID: <4629547D.9090404@goop.org>
Date: Fri, 20 Apr 2007 17:02:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
Subject: Re: [2/2] 2.6.21-rc7: known regressions
References: <20070416003723.GM3691@stusta.de> <4628482B.6040804@goop.org> <20070420050344.GG20566@redhat.com> <46284C84.6060301@goop.org> <20070420051908.GH20566@redhat.com> <462850B3.70901@goop.org> <20070420145126.GC25051@redhat.com> <4628DC0A.60707@goop.org> <20070420160308.GB20118@redhat.com> <4628F586.3040606@goop.org> <20070420172147.GC20118@redhat.com>
In-Reply-To: <20070420172147.GC20118@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Fri, Apr 20, 2007 at 10:16:54AM -0700, Jeremy Fitzhardinge wrote:
>  > Dave Jones wrote:
>  > >  > Andi, I think.  I've got his firstfloor.org patches applied to this kernel.
>  > >
>  > > Ah, I saw you patched in CFS too, and thought it may be related.
>  > >   
>  > 
>  > Well, I have CONFIG_FB_BACKLIGHT enabled, and it still works.
>  > 
>  > Maybe there's something in Andi's queue which is making it work?
>
> Shrug, I'm out of ideas.  I'm hoping that it'll magically start working
> when people start flushing their git trees for .22
> Maybe that'll yield a clue for something that can be backported to .21.x
> because right now, I'm completely puzzled.

Well, it seemed reliable, but I just got a resume failure.  Different
from any previous symptom I've seen:

Intel machine check architecture supported
Intel machine check reporting enabled enabled on CPU#1
Back to C!
<hang>

    J
