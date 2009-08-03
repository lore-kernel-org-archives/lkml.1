Return-Path: <linux-kernel-owner+w=401wt.eu-S932372AbZHCXoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbZHCXoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 19:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932360AbZHCXoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 19:44:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44709 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932357AbZHCXoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 19:44:09 -0400
Date: Mon, 3 Aug 2009 19:44:00 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: cpufreq tree build failure
Message-ID: <20090803234400.GA16934@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090803122819.6b738cad.sfr@canb.auug.org.au> <200908040122.15733.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908040122.15733.trenn@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 01:22:14AM +0200, Thomas Renninger wrote:
 > On Monday 03 August 2009 04:28:19 am Stephen Rothwell wrote:
 > > Hi Dave,
 > >
 > > Today's linux-next build (x86_64 allmodconfig) failed like this:
 > >
 > > ERROR: "cpufreq_global_kobject" [drivers/cpufreq/cpufreq_ondemand.ko]
 > > undefined!
 > >
 > > Caused by commit 35b104d88338e5eddb36c670fea4752f6c10c82f ("[CPUFREQ]
 > > ondemand - Use global sysfs dir for tuning settings").  Presumably
 > > cpufreq_global_kobject needs an EXPORT_SYMBOL.
 > 
 > Yep, that's it. Below is a fix.
 > 
 > Thanks a lot,

I'll roll this in with the previous patch, so as not to introduce
a bisect-regression, and rebase the tree. Will push something out
soon.

thanks.

	Dave
