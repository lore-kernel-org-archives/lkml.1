Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbZIHWGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbZIHWGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZIHWGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:06:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbZIHWGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:06:23 -0400
Date: Tue, 8 Sep 2009 15:06:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: reinette chatre <reinette.chatre@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>
Subject: Re: [Bug #13819] system freeze when switching to console
In-Reply-To: <20090908123151.1f2b18fe@jbarnes-g45>
Message-ID: <alpine.LFD.2.01.0909081502510.7458@localhost.localdomain>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera> <Vm51Upp4EV.A.r-D.mgBpKB@chimera> <1252427375.14735.130.camel@rc-desk> <alpine.LFD.2.01.0909080943030.7458@localhost.localdomain> <1252431375.14735.139.camel@rc-desk> <alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
 <20090908112014.002a35af@jbarnes-g45> <alpine.LFD.2.01.0909081219130.7458@localhost.localdomain> <20090908123151.1f2b18fe@jbarnes-g45>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Sep 2009, Jesse Barnes wrote:
> 
> Yeah, saw that.  I don't think that's the root cause though.  If we see
> a user interrupt after gem_idle is called we may have serious issues in
> our command handling code.

Quite frankly, I do not understand why you seem to be making excuses for 
code that causes a very nasty and undebuggable oops, causing the machine 
to die. 

This regression is almost two months old, and apparently the Intel 
graphics people DID ABSOLUTELY NOTHING about it during those two months, 
because they couldn't be bothered to look at it.

And now, when I pinpointed exactly where the oops happens, and what the 
cause is, you seem to be trying to hold things up. I wanted to do the 
final 2.6.31 release yesterday, quite frankly I'm not in the _least_ 
interested in excuses, I'm interested in something that at least gets us 
back to the 2.6.30 state that doesn't oops!

Get me a patch, please. If disabling the interrupts early won't work, get 
me something else. Stop delaying it - it's been pending for 48 days 
already.

		Linus
