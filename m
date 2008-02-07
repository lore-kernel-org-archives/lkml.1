Return-Path: <linux-kernel-owner+w=401wt.eu-S1758391AbYBGJsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391AbYBGJsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYBGJsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:48:11 -0500
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:34473
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbYBGJsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:48:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=mpDb_OsCwBSZZfC2BvIA:9
 a=ydNyLYV7TuR6P14BAcx3STDQ0CEA:4 a=jXk-Exju8_oA:10
Subject: Re: 2.6.24-git15 Keyboard Issue?
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
References: <1202302978.9058.13.camel@popeye>
	 <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>
	 <1202305740.9058.22.camel@popeye>
	 <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
	 <1202318666.6406.13.camel@popeye>
	 <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 03:51:36 -0600
Message-Id: <1202377896.6406.38.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jiri - 

I have just started the build on the 2.6.24-git16 product and when it is
done I will come up with just the nohpet parameter - forgoing the
previouosly used taskset command.

Do you want me to do this using the git15 kernel I built yesterday, or
the new git16 kernel?

(I was not sure if you wanted me to introduce the variable of a new
kernel into the process while you are trying to diagnose the failure)

On the topic of doing a git bisect - I am recovering from heart surgery
last week and other than keeping up with the never ending stream of
email from the office, I am pretty much confined to the house - so I
have nothing but time on my hands.

However, I do my daily builds from the main tarball merged with the
daily git patch and don't have the infrustructure set up to do a git
bisect.  If you can point me to a "how to" on how to set up and use git
I am more than willing to give it a shot.

Chris



On Thu, 2008-02-07 at 10:18 +0100, Jiri Kosina wrote:
> On Wed, 6 Feb 2008, Chris Holvenstot wrote:
> 
> > I have several hours of running aith nohpet and X's affinity set to 2
> > instead of 3 and so far everything is running flawlessly.
> 
> Great, so this definitely is some kind of timing issue, thanks for 
> verifying that.
> 
> > which has the same suggestion (taskset) as you made, for me this was 
> > something new starting with 2.6.24-git15 - maybe something made a timing 
> > issue fall a little closer to the edge.
> 
> Yes, could be some scheduler update that made the problem more visible. If 
> you'd had time to use git-bisect to find the exact commit that exposes 
> your problem, that might be interesting. But as you said that this is not 
> immediately reproducible, it might take ages.
> 
> > Would you like me to try and further isolate things for you here by 
> > either running with just nohpet OR just the taskset to change X's 
> > affinity?
> 
> Yes, that would help. Especially knowing whether running with 'nohpet' 
> fixes the problem would be nice.
> 

