Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbXJ0CbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbXJ0CbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 22:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbXJ0CbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 22:31:13 -0400
Received: from mx1.suse.de ([195.135.220.2]:47756 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbXJ0CbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 22:31:12 -0400
Date: Fri, 26 Oct 2007 19:36:12 -0700
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
Message-ID: <20071027023612.GC28858@suse.de>
References: <47221E6F.1090607@lwfinger.net> <1193422064.2190.6.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193422064.2190.6.camel@lov.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 08:07:44PM +0200, Kay Sievers wrote:
> On Fri, 2007-10-26 at 12:05 -0500, Larry Finger wrote:
> > On my openSUSE 10.3 x86_64 system running v2.6.24-rc1-281-g22d2aa1,
> > I get the sysfs rename messages.
> 
> Care to try this? Seems like a silly bug in the core if
> SYSFS_DEPRECATED=y. That's why we didn't catch this earlier, sorry.
> 
> Thanks a lot for the help,
> Kay
> 
> 
> 
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: Driver Core: fix bug in device_rename() for SYSFS_DEPRECATED=y
> 

Do you have some more information for the change log here?  Are we just
not unwinding from errors properly?

This should get so much better and easier to test with the sysfs version
number in the future :)

thanks,

greg k-h
