Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbXLCVQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbXLCVQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbXLCVQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:16:03 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38034 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbXLCVQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:16:01 -0500
Subject: Re: Error returns not handled
	correctly	by	sysfs.c:subsys_attr_store()
From: Andrew Patterson <andrew.patterson@hp.com>
To: Tejun Heo <teheo@suse.de>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
In-Reply-To: <474E10CF.7050009@suse.de>
References: <1195683419.16019.225.camel@grinch>
	 <20071126203116.0c93cdb9.akpm@linux-foundation.org>
	 <20071127053321.GA975@kroah.com>  <474D1BD4.2050805@suse.de>
	 <1196278300.5431.9.camel@grinch>  <474E10CF.7050009@suse.de>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 14:15:58 -0700
Message-Id: <1196716558.20124.179.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-29 at 10:07 +0900, Tejun Heo wrote:
> Andrew Patterson wrote:
> > I tried with clean 2.6.24-rc3 and get the same bad behavior.  This is on
> > an ia64 box, so maybe that is an issue. I can try on an x86 box as well.
> > Oh, one other thing.  I tried a "uname -r" to make sure I had the
> > correct kernel booted and got:
> > 
> > # uname -r
> > 2.6.24-rc3
> > x
> > y
> > z
> > #
> 
> Yeah, please try it on another machine from clean tree.  sysfs code is
> definitely not endian dependent and is 64 bit clean.  Heck, all my test
> machines run 64 bit these days.  I would be surprised if it's something
> architecture dependent but please try on a different machine with
> different userland with kernel built from fresh source tree.
> 
> Thanks.

I tried this on a AMD system running an i386 kernel. I get the same bad
behavior.  This is from a 2.6.24-rc3 kernel downloaded from kernel.org.
I ran "make mrproper" followed by "make oldconfig" and accepted all the
defaults for the config.

There is one slight change with this experiment.  Other nodes are not
getting corrupted, i.e., uname -r is getting the correct value.

-- 
Andrew Patterson
Hewlett-Packard Company

