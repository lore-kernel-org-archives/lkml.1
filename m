Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZKQCE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZKQCE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 21:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbZKQCEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 21:04:55 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:46295 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbZKQCEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 21:04:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TKZS0hosA3LzOUQHHaLYvu8m7p8aQjNvNgpxGn09LISGFmpY6kvnirB6YXkJRGQ6M1
         LdgGBULM/Qow9U4v9IzKTj8lGTyHKalA9al1+8BtehwWXjJq4Tvf5w6cSQiJCUiU4PSB
         /+lG1bURM1Fi9wKMw1qgcs5SyDr2gIfh2Onsg=
Date: Mon, 16 Nov 2009 18:04:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Soeren Sonnenburg <sonne@debian.org>
Subject: Re: [Bug #14626] oops on boot starting udev
Message-ID: <20091117020451.GA27967@core.coreip.homeip.net>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.fpF.zSdALB@chimera> <20091117011455.GA7977@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117011455.GA7977@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 05:14:55PM -0800, Greg KH wrote:
> On Mon, Nov 16, 2009 at 11:37:48PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14626
> > Subject		: oops on boot starting udev
> > Submitter	: Soeren Sonnenburg <sonne@debian.org>
> > Date		: 2009-11-14 10:16 (3 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125819380206800&w=4
> 
> This looks like an input core problem, as the evdev module was just
> loaded and died.
> 
> Any input developers have any ideas?
> 


Hmm, evdev does:

	dev_set_name(&evdev->dev, "event%d", minor);

Not sure how it can go wrong...

-- 
Dmitry
