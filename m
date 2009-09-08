Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbZIHXQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbZIHXQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZIHXQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:16:57 -0400
Received: from outbound-mail-154.bluehost.com ([67.222.39.34]:51651 "HELO
	outbound-mail-154.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750910AbZIHXQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:16:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=rwX4lXkn9ru8DHkG6rd8DbjeH4yS2s1D3MITbpf3kYN5GjB+BWvJbjBOWePWP+MmVozrgUkXKxZMt2h8BH53Rl+JlJm8Aw0rBvTqrZnOSezWnLl66MS5tUMDNX6FcXDg;
Date: Tue, 8 Sep 2009 16:16:57 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>
Subject: Re: [Bug #13819] system freeze when switching to console
Message-ID: <20090908161657.0f21c7fb@jbarnes-g45>
In-Reply-To: <1252449461.30150.61.camel@rc-desk>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
	<Vm51Upp4EV.A.r-D.mgBpKB@chimera>
	<1252427375.14735.130.camel@rc-desk>
	<alpine.LFD.2.01.0909080943030.7458@localhost.localdomain>
	<1252431375.14735.139.camel@rc-desk>
	<alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
	<1252449461.30150.61.camel@rc-desk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Sep 2009 15:37:41 -0700
reinette chatre <reinette.chatre@intel.com> wrote:

> On Tue, 2009-09-08 at 11:06 -0700, Linus Torvalds wrote:
> > so this is TOTALLY UNTESTED!
> 
> I understand that the discussion is still going on whether this is the
> right thing to do. Even so, I thought you may like to know that with
> this patch I can again switch to console, back again, hibernate, and
> shut down .. all without crashing my system.
> 
> Tested-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> Thank you very much!

Do you see "hardware wedged" messages in your log after using Linus's
patch?  That's what I'd expect...  ah no I see we don't call the
routine that requires interrupts in that path like I thought.

So Linus's patch is fine with me.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Sorry Linus, you were right; I was making this more complicated than it
had to be.

-- 
Jesse Barnes, Intel Open Source Technology Center
