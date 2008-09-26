Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYIZOXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYIZOXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 10:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYIZOXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 10:23:37 -0400
Received: from mail.suse.de ([195.135.220.2]:34411 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbYIZOXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 10:23:37 -0400
Date: Fri, 26 Sep 2008 16:23:34 +0200
From: Karsten Keil <kkeil@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: e1000e NVM corruption issue status
Message-ID: <20080926142334.GA554@pingi.kke.suse.de>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com> <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.27-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 07:01:21PM -0700, Brandeburg, Jesse wrote:
> > We have a series of kernel patches that I will reply to this mail with 
> > that may help users willing to test.
> 
> this is the current set of patches that I have to help us debug
> and/or fix e1000e issues found during this debug effort for
> the corrupt NVM.  the "drop stats lock" - "reset swflag" patches allow 
> Thomas' patch for a mutex in the SWFLAG acquire function to run without 
> any errors.
> 
> the patches are not probably production quality, but seem to work
> for myself and thomas on at least a couple of machines.
> 
> The non-debug aspects of the patches will likely be pushed later.
> 
> At this point I do not believe any of these patches will fix the
> NVM corruption issue, but will add to the ability of any tester
> to help find the issue, and reduce the chance that it is any issue we 
> (now) know about.
> 

A kernel with this these patches load the e1000e driver fine on
a test machine which has a OK NVM checksum.

But it freeze on one machine which has a wrong checksum.

On this machine the NVM seems to be OK, but the NVM valid bit
is cleared. If I would set this bit, the NVM checksum would be OK
again. This is the T61 notebook which did show this error after
openSUSE 11.1 Beta1 install after a reboot during X setup. 


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
