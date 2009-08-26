Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbZHZKKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbZHZKKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbZHZKKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:10:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:53560 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688AbZHZKKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:10:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="180324887"
Subject: Re: Linux 2.6.31-rc7
From: ykzhao <yakui.zhao@intel.com>
To: mailing54 <mailing54@plzk.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Anholt <eric@anholt.net>, mailing54 <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "Ma, Ling" <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Keith Packard <keithp@keithp.com>
In-Reply-To: <20090826035840.GA16894@zhen-devel.sh.intel.com>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
	 <4A941E8B.8080902@plzk.org>
	 <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain>
	 <4A94599F.9020508@plzk.org>
	 <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
	 <1251239637.26348.20.camel@gaiman.anholt.net>
	 <20090826015127.GA1402@zhen-devel.sh.intel.com>
	 <alpine.LFD.2.01.0908252027300.3218@localhost.localdomain>
	 <20090826035840.GA16894@zhen-devel.sh.intel.com>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Wed, 26 Aug 2009 18:09:58 +0800
Message-Id: <1251281398.3623.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 11:58 +0800, Zhenyu Wang wrote:
Hi
    From the config file it seems that the CONFIG_FRAMEBUFFER_CONSOLE is
set as m.
    Will you please set it to y and see whether the black screen
happens?
  
Thanks.
   Yakui
> On 2009.08.25 20:33:32 -0700, Linus Torvalds wrote:
> > On Wed, 26 Aug 2009, Zhenyu Wang wrote:
> > >
> > > > In my experience, the BIOS setup doesn't reflect what outputs should be
> > > > used at runtime, and certainly not the correct configuration of the
> > > > enabled outputs.  For example, if we went to this, the giant monitor
> > > > attached to my laptop that I actually look at would go unused.
> > > 
> > > yeah, normally VBIOS startup just needs or only can driver one pipe, so
> > > we don't have any pre knowledge except detect everything.
> > 
> > Umm. What's your guys point, exactly?
> > 
> 
> We can't depend on any BIOS display config as you noted before our driver.
> And our driver does more flexible config than VBIOS does.
> 
> > The fact is, as-is, YOU DETECT THE WRONG OUTPUTS!
> > 
> > If you actually detected things _right_, none of this would be an issue. 
> > But you don't. And you seem to have a really hard time even admitting 
> > that. You try to re-detect things, and you SCREW UP.
> > 
> 
> We know we have problem on Mac mini, this issue has been known for a while.
> And Keith also posted patch at
> 	http://lists.freedesktop.org/archives/intel-gfx/2009-June/002843.html
> but I don't know the status of this now.
> 
> > > we already have some mac relate bugs open, but please report on it so we
> > > do have people with hardware to try and response. We have recently got a
> > > MacBook, yakui is looking after the modesetting issue on it.
> > 
> > Quite frankly, I've reported these things several times. I've been open to 
> > try patches. Nothing has ever come out of it. 
> > 
> > I have a Mac Mini that I reported as broken over a month ago. I have a 
> > Westemere I've reported as not doing any DDC probing - and that I have to 
> > disable the LVDS probing on entirely in order to not make KMS set up the 
> > display to go to a non-existent LVDS port.
> > 
> > You claim that you "detect everything", but quite frankly, you don't. The 
> > KMS code seems to assume that if it's a mobile chipset, it should have an 
> > LVDS output - and whether anything is connected to that or not is totally 
> > immaterial. There's clearly _zero_ "detection" going on.
> > 
> 
> We've tried many ways to detect LVDS, but none is stable or actually work for
> every chip. But now we have DMI quirks for some known no LVDS machine (including
> Mac mini), and we detect through ACPI LID object for LVDS exist. 
> 

