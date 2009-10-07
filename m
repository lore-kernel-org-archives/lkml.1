Return-Path: <linux-kernel-owner+w=401wt.eu-S934238AbZJGRsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238AbZJGRsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757979AbZJGRsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:48:20 -0400
Received: from mail.lang.hm ([64.81.33.126]:55439 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757766AbZJGRsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:48:19 -0400
Date: Wed, 7 Oct 2009 10:44:11 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Mike Galbraith <efault@gmx.de>
cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <1254927134.7121.36.camel@marge.simson.net>
Message-ID: <alpine.DEB.2.00.0910071040560.11706@asgard.lang.hm>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>  <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>  <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>  <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> 
 <1254864803.6035.25.camel@pasglop>  <alpine.LFD.2.01.0910061513510.3432@localhost.localdomain>  <21d7e9970910061822i429344amb47b0bceb552abc6@mail.gmail.com>  <alpine.LFD.2.01.0910062015200.3432@localhost.localdomain>  <alpine.LFD.2.01.0910062025300.3432@localhost.localdomain>
  <20091007135233.GK17883@mit.edu> <1254927134.7121.36.camel@marge.simson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Mike Galbraith wrote:

> On Wed, 2009-10-07 at 09:52 -0400, Theodore Tso wrote:
>
>> The one thing that I wish we *could* do is make
>> CONFIG_LOCALVERSION_AUTO mandatory, or at least making it the strong
>> default and forcing people to work to turn it off, since the problem
>> really is with users smart enough to use git, but not quite smart
>> enough to turn on CONFIG_LOCALVERSION_AUTO.
>
> There are also those who use git, but turn CONFIG_LOCALVERSION_AUTO off
> for a reason, because it just annoys them with zero gain.
>
> I don't do -rcX.  I have one tree per installed kernel.  When Linus
> pulls a release out of the oven, on that day, Makefile becomes rev++ for
> a new tree and stays that way until he declares the next one baked.  Old
> tree stays frozen at rev until it becomes .stable.  My repos are always
> frozen at where the installed kernel is at, so adding an extra version
> is just a work generating irritant.
>
> I'd like having git ID embedded in the kernel for idiot proofing, but I
> don't like it polluting my installs, so I live without it.

as I understand it, if you only use the released kernel then 
CONFIG_LOCALVERSION_AUTO will make no difference to you.

the kernel string only changes if you use a non-release kernel.

David Lang


