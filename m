Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZKQBSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZKQBSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 20:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbZKQBSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 20:18:02 -0500
Received: from kroah.org ([198.145.64.141]:38451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbZKQBSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 20:18:01 -0500
Date: Mon, 16 Nov 2009 17:14:55 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-input@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Soeren Sonnenburg <sonne@debian.org>
Subject: Re: [Bug #14626] oops on boot starting udev
Message-ID: <20091117011455.GA7977@kroah.com>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
 <xXQGFmujPl.A.fpF.zSdALB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xXQGFmujPl.A.fpF.zSdALB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 11:37:48PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14626
> Subject		: oops on boot starting udev
> Submitter	: Soeren Sonnenburg <sonne@debian.org>
> Date		: 2009-11-14 10:16 (3 days old)
> References	: http://marc.info/?l=linux-kernel&m=125819380206800&w=4

This looks like an input core problem, as the evdev module was just
loaded and died.

Any input developers have any ideas?

thanks,

greg k-h
