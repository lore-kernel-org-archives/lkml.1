Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZHZDeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZHZDeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 23:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbZHZDeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 23:34:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756485AbZHZDeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 23:34:07 -0400
Date: Tue, 25 Aug 2009 20:33:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Zhenyu Wang <zhenyuw@linux.intel.com>
cc: Eric Anholt <eric@anholt.net>, mailing54 <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       Ma Ling <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: Linux 2.6.31-rc7
In-Reply-To: <20090826015127.GA1402@zhen-devel.sh.intel.com>
Message-ID: <alpine.LFD.2.01.0908252027300.3218@localhost.localdomain>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain> <4A941E8B.8080902@plzk.org> <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain> <4A94599F.9020508@plzk.org> <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
 <1251239637.26348.20.camel@gaiman.anholt.net> <20090826015127.GA1402@zhen-devel.sh.intel.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Aug 2009, Zhenyu Wang wrote:
>
> > In my experience, the BIOS setup doesn't reflect what outputs should be
> > used at runtime, and certainly not the correct configuration of the
> > enabled outputs.  For example, if we went to this, the giant monitor
> > attached to my laptop that I actually look at would go unused.
> 
> yeah, normally VBIOS startup just needs or only can driver one pipe, so
> we don't have any pre knowledge except detect everything.

Umm. What's your guys point, exactly?

The fact is, as-is, YOU DETECT THE WRONG OUTPUTS!

If you actually detected things _right_, none of this would be an issue. 
But you don't. And you seem to have a really hard time even admitting 
that. You try to re-detect things, and you SCREW UP.

> we already have some mac relate bugs open, but please report on it so we
> do have people with hardware to try and response. We have recently got a
> MacBook, yakui is looking after the modesetting issue on it.

Quite frankly, I've reported these things several times. I've been open to 
try patches. Nothing has ever come out of it. 

I have a Mac Mini that I reported as broken over a month ago. I have a 
Westemere I've reported as not doing any DDC probing - and that I have to 
disable the LVDS probing on entirely in order to not make KMS set up the 
display to go to a non-existent LVDS port.

You claim that you "detect everything", but quite frankly, you don't. The 
KMS code seems to assume that if it's a mobile chipset, it should have an 
LVDS output - and whether anything is connected to that or not is totally 
immaterial. There's clearly _zero_ "detection" going on.

And the thing is, X seems to get it right, at least more often than KMS 
does. 

			Linus
