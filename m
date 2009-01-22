Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZAVV7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZAVV7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZAVV7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:59:23 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:39553 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZAVV7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:59:21 -0500
Message-ID: <4978EBE1.9080403@oracle.com>
Date: Thu, 22 Jan 2009 13:57:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
References: <20090109165422.GF24884@logfs.org> <20090109193738.GA9827@linode.davidb.org> <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu> <Pine.LNX.4.64.0901111022590.30201@anakin> <20090111153920.GC7401@elte.hu> <20090111163018.GA9300@suse.de> <20090122215041.GA29369@redhat.com>
In-Reply-To: <20090122215041.GA29369@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4978EBF4.0033:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Sun, Jan 11, 2009 at 08:30:18AM -0800, Greg KH wrote:
> 
>  > I was wanting to stick with drivers to start with, but I really have no
>  > objection to adding filesystems, if they are self-contained, to the
>  > drivers/staging/ directory.
>  > 
>  > I looked at adding squashfs, but at the time, it touched other portions
>  > of the kernel which wouldn't have made it a good canidate for staging.
>  > This was later resolved, and now that it is merged, it's a moot issue :)
>  > 
>  > So, if anyone wants to send me filesystems, I'll be glad to take them
>  > into drivers/staging, as long as they are self-contained (novfs for
>  > example would fit this category.)
> 
> Filesystems in staging worries me.
> 
> * The number of people who competently review filesystem code
>   (and I mean real review here, not checkpatch & codingstyle crap)
>   is significantly less than those who review drivers.
>   I foresee stuff just lingering there for years.
>   (Look how long fs stuff hangs around unmerged in -mm for example).
>  
> * The fallout of staging is already starting to drift into distros.
>   Within a week of Fedora shipping a kernel that had staging/
>   we had requests to enable drivers from it.
>   And of course, those drivers were garbage.
>   This is only going to increase as time goes on.
> 
> * For crap drivers that a minority cares about, this isn't a big deal
>   to tell the users "build it yourself, we don't support it when stuff breaks".
>   (And a lot of that crap will break.  NetworkManager won't work properly
>    with some of the wireless crap in staging for example), but by
>   continually adding to the shitpile the potential for review dramatically
>   gets reduced, and for something as critical as a filesystem, I find this
>   absolutely terrifying from a support perspective.
> 
> I don't mean to piss on your parade, but from my viewpoint, staging
> is a trainwreck so far, and I'd hate to see it get worse.
> 
> We've already demonstrated "look how much stuff we can merge" time and
> time again, but no-one ever seems to have a proposal for how we increase
> the amount of review code gets before it's merged.
> 
> There's lowering the barrier for entry, and there's not having a barrier at all.
> The latter is what I'm concerned that staging/ has become.

I agree.  Alexey D. asked about that a few days ago and the Greg's answer
about what he would accept was "anything".  Ugh ugh ugh.  I did not like
that reply at all.

I agree that crap is the right name for lots of it.  For the ones that
people & distros care about, someone should step up and do some real
work on them.



~Randy
