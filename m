Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbZIHWLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbZIHWLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZIHWLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:11:37 -0400
Received: from outbound-mail-310.bluehost.com ([67.222.54.3]:43214 "HELO
	outbound-mail-310.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752039AbZIHWLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:11:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LgxqubHXrfbA3LfKsJcDbarPjmVQjh6iX4/+Y71L2SaU9m5mKdSprpa/Ng2gXNA6ChHF2StDclTaVp8ggvcPt8nEIsla6zl0UOap3sOf3hz3EF1P8hWd2wAgpDaIYrsZ;
Date: Tue, 8 Sep 2009 15:11:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>
Subject: Re: [Bug #13819] system freeze when switching to console
Message-ID: <20090908151135.7ba64801@jbarnes-g45>
In-Reply-To: <alpine.LFD.2.01.0909081502510.7458@localhost.localdomain>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
	<Vm51Upp4EV.A.r-D.mgBpKB@chimera>
	<1252427375.14735.130.camel@rc-desk>
	<alpine.LFD.2.01.0909080943030.7458@localhost.localdomain>
	<1252431375.14735.139.camel@rc-desk>
	<alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
	<20090908112014.002a35af@jbarnes-g45>
	<alpine.LFD.2.01.0909081219130.7458@localhost.localdomain>
	<20090908123151.1f2b18fe@jbarnes-g45>
	<alpine.LFD.2.01.0909081502510.7458@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009 15:06:21 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 8 Sep 2009, Jesse Barnes wrote:
> > 
> > Yeah, saw that.  I don't think that's the root cause though.  If we
> > see a user interrupt after gem_idle is called we may have serious
> > issues in our command handling code.
> 
> Quite frankly, I do not understand why you seem to be making excuses
> for code that causes a very nasty and undebuggable oops, causing the
> machine to die. 

No excuses.  This is a serious bug; I just don't want to paper over it.

> This regression is almost two months old, and apparently the Intel 
> graphics people DID ABSOLUTELY NOTHING about it during those two
> months, because they couldn't be bothered to look at it.

Yeah sorry, this is the first I've seen of it...  I usually troll the
regressions lists but I must have missed this one.

> And now, when I pinpointed exactly where the oops happens, and what
> the cause is, you seem to be trying to hold things up. I wanted to do
> the final 2.6.31 release yesterday, quite frankly I'm not in the
> _least_ interested in excuses, I'm interested in something that at
> least gets us back to the 2.6.30 state that doesn't oops!
> 
> Get me a patch, please. If disabling the interrupts early won't work,
> get me something else. Stop delaying it - it's been pending for 48
> days already.

Sure, looking at it now.

-- 
Jesse Barnes, Intel Open Source Technology Center
