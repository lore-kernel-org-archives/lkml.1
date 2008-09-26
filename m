Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYIZRx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYIZRx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 13:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbYIZRxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 13:53:21 -0400
Received: from outbound-mail-105.bluehost.com ([69.89.18.5]:47504 "HELO
	outbound-mail-105.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752596AbYIZRxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 13:53:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Ib2zvFKzmdtNrHPH2s1QGEAPSWRxSbuLL6vBwVopCbcdHGWjFVpQOVTf8irRo1QnDRP9Tl/1oN5Bhk2MYS0KgCK1PlCCIhPFXh8C1YWfMvL+GdY4cIQsqmzEmLWnP194;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: e1000e NVM corruption issue status
Date: Fri, 26 Sep 2008 10:52:34 -0700
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, agospoda@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <alpine.LNX.1.10.0809260812130.14480@pegasus.suse.cz> <48DCCC5F.8040609@linux.intel.com>
In-Reply-To: <48DCCC5F.8040609@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809261052.38966.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 26, 2008 4:49 am Arjan van de Ven wrote:
> Jiri Kosina wrote:
> > On Thu, 25 Sep 2008, Brandeburg, Jesse wrote:
> >> this is the current set of patches that I have to help us debug
> >> and/or fix e1000e issues found during this debug effort for
> >> the corrupt NVM.  the "drop stats lock" - "reset swflag" patches allow
> >> Thomas' patch for a mutex in the SWFLAG acquire function to run without
> >> any errors.
> >
> > Thanks. Also Jesse Barnes' patch shouldn't be forgotten, could you please
> > add it to that lineup?
> >
> > 	http://marc.info/?l=linux-kernel&m=122237193628087&w=2
>
> can we (for now) also stick a WARN_ON() into that failure path? that way we
> can at least catch if/when this happens more visibly..... if it happens
> consistently in say the new distros we can be more confident that we're
> down the right path in diagnosing the issue.

I'm spinning a new one now with some debug output, stay tuned (just gotta boot 
my test box).

-- 
Jesse Barnes, Intel Open Source Technology Center
