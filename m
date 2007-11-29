Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbXK2BHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbXK2BHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762146AbXK2BHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:07:34 -0500
Received: from ns1.suse.de ([195.135.220.2]:43647 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760183AbXK2BHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:07:33 -0500
Message-ID: <474E10CF.7050009@suse.de>
Date: Thu, 29 Nov 2007 10:07:27 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: Error returns not handled correctly	by	sysfs.c:subsys_attr_store()
References: <1195683419.16019.225.camel@grinch>	 <20071126203116.0c93cdb9.akpm@linux-foundation.org>	 <20071127053321.GA975@kroah.com>  <474D1BD4.2050805@suse.de> <1196278300.5431.9.camel@grinch>
In-Reply-To: <1196278300.5431.9.camel@grinch>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Patterson wrote:
> I tried with clean 2.6.24-rc3 and get the same bad behavior.  This is on
> an ia64 box, so maybe that is an issue. I can try on an x86 box as well.
> Oh, one other thing.  I tried a "uname -r" to make sure I had the
> correct kernel booted and got:
> 
> # uname -r
> 2.6.24-rc3
> x
> y
> z
> #

Yeah, please try it on another machine from clean tree.  sysfs code is
definitely not endian dependent and is 64 bit clean.  Heck, all my test
machines run 64 bit these days.  I would be surprised if it's something
architecture dependent but please try on a different machine with
different userland with kernel built from fresh source tree.

Thanks.

-- 
tejun
