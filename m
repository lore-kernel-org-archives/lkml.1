Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbXK3WXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbXK3WXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbXK3WXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:23:23 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:54130 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbXK3WXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:23:23 -0500
Message-ID: <47508D3C.9050507@keyaccess.nl>
Date: Fri, 30 Nov 2007 23:22:52 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Chris Holvenstot <cholvenstot@comcast.net>
CC: linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, bjorn.helgaas@hp.com,
       trenn@suse.de
Subject: Re: pnpacpi : exceeded the max number of IO resources
References: <1196428488.7066.6.camel@localhost>
In-Reply-To: <1196428488.7066.6.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-11-07 14:14, Chris Holvenstot wrote:

> For what it is worth I too have seen this problem this morning and it
> DOES appear to be new (in contrast to a previous comment)
> 
> The message:  pnpacpi: exceeded the max number of mem resources: 12
> 
> is displayed each time the system is booted with the 2.6.24-rc3-git5
> kernel but is NOT displayed when booting 2.6.24-rc3-git4
> 
> I have made no changes in my config file between these two kernels other
> than to accept any new defaults when running make oldconfig.
> 
> If you had already narrowed it down to a change between git4 and git5 I
> apologize for wasting your time.  Have to run to work now.

Thanks, and re-added the proper CCs. Sigh...

Well, yes, the warning is actually new as well. Previously your kernel just 
silently ignored 8 more mem resources than it does now it seems.

Given that people are hitting these limits, it might make sense to just do 
away with the warning for 2.6.24 again while waiting for the dynamic code?

Rene.
