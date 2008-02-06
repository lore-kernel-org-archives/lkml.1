Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYBFRVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYBFRVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYBFRVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:21:04 -0500
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:55927
	"EHLO QMTA05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbYBFRVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:21:02 -0500
X-Authority-Analysis: v=1.0 c=1 a=1nSz6Ew-AAAA:8 a=V2R780MibZq09H6Q6nIA:9
 a=u9zz375IJi8iEfPZyfIA:7 a=3zB11BuSq5KeDg0O24OpFWHHLhMA:4 a=uv1ck3d6JtEA:10
Subject: Re: 2.6.24-git15 Keyboard Issue?
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
References: <1202302978.9058.13.camel@popeye>
	 <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>
	 <1202305740.9058.22.camel@popeye>
	 <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 11:24:26 -0600
Message-Id: <1202318666.6406.13.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri - 

I have several hours of running aith nohpet and X's affinity set to 2
instead of 3 and so far everything is running flawlessly.

Even though Mark Hounschell pointed me at this old Suse issue 

(https://bugzilla.novell.com/show_bug.cgi?id=223561)

which has the same suggestion (taskset) as you made, for me this was
something new starting with 2.6.24-git15 - maybe something made a timing
issue fall a little closer to the edge.  

Would you like me to try and further isolate things for you here by
either running with just nohpet OR just the taskset to change X's
affinity?

Once again thank you for your prompt (and effective) support on this
issue.

Chris




On Wed, 2008-02-06 at 14:54 +0100, Jiri Kosina wrote:
> On Wed, 6 Feb 2008, Chris Holvenstot wrote:
> 
> > On this system I am using a PS2 Keyboard - and let me stress that it is 
> > only occasionaly that it happens - I have had 2.6.24-git15 up for about 
> > 2 hours now and have only seen it about a dozen times. I also note one 
> > other thing - although my system is lightly loaded - at this time of day 
> > I am pretty much just using email on an AMD 64 X2 4600+ with 2 gigs of 
> > of memory - I have noticed several times that I will be typing away and 
> > nothing is appearing on the screen - and a few seconds later - boom - 
> > there it all is.
> 
> It could be some timing problem. Does this happen also in console, or 
> only when running X?
> 
> Could you please try to
> 
> - boot with 'nohpet' kernel parameter
> - taskset -p 0x00000002 <pid_of_Xserver> if this is a multi-CPU/core 
>   machine and you are experiencing the problems only in X
> 
> Thanks,
> 

