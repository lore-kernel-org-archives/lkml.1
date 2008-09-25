Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYIYVti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYIYVti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbYIYVt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:49:29 -0400
Received: from styx.suse.cz ([82.119.242.94]:59763 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752908AbYIYVt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:49:28 -0400
Date: Fri, 26 Sep 2008 00:45:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dave Airlie <airlied@gmail.com>
cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <21d7e9970809251445s216efcc3kaba639d5e29c51aa@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0809260042380.3389@pegasus.suse.cz>
References: <20080923.150722.141587696.davem@davemloft.net>  <200809251156.10648.jbarnes@virtuousgeek.org>  <alpine.LNX.1.10.0809252218470.3389@pegasus.suse.cz>  <200809251236.12287.jbarnes@virtuousgeek.org>  <alpine.LNX.1.10.0809252234400.3389@pegasus.suse.cz>
  <21d7e9970809251406gb2bdacbuf9ff1bde3d118cdb@mail.gmail.com>  <4807377b0809251442x67e4e9eia706b70ae1c177ca@mail.gmail.com> <21d7e9970809251445s216efcc3kaba639d5e29c51aa@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008, Dave Airlie wrote:

> >> I'd target three areas PAT, pciaccess and e1000e itself.
> > ubuntu has CONFIG_X86_PAT disabled for at least i386 arch, maybe that
> > is relevant.
> It rules out PAT I suppose, they have seen the issue as well.

I wasn't able to rule out PAT from the suse bugreports POV, as we have PAT 
enabled both for 32bit and 64bit x86.

If Ubuntu has it disabled also for 64bit x86 (where do these guys have 
.config files to check?), I think we can definitely rule out PAT, as there 
has been at least one report from Ubuntu user on this very issue.

-- 
Jiri Kosina
SUSE Labs
