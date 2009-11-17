Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZKQC7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZKQC7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 21:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZKQC7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 21:59:05 -0500
Received: from nn7.de ([85.214.94.156]:53091 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZKQC7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 21:59:04 -0500
Subject: Re: [Bug #14626] oops on boot starting udev
From: Soeren Sonnenburg <sonne@debian.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <greg@kroah.com>, "Rafael J\. Wysocki" <rjw@sisk.pl>,
       linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <20091117020451.GA27967@core.coreip.homeip.net>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
	 <xXQGFmujPl.A.fpF.zSdALB@chimera> <20091117011455.GA7977@kroah.com>
	 <20091117020451.GA27967@core.coreip.homeip.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Tue, 17 Nov 2009 03:59:03 +0100
Message-ID: <1258426743.9883.53.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 18:04 -0800, Dmitry Torokhov wrote:
> On Mon, Nov 16, 2009 at 05:14:55PM -0800, Greg KH wrote:
> > On Mon, Nov 16, 2009 at 11:37:48PM +0100, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.31.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14626
> > > Subject		: oops on boot starting udev
> > > Submitter	: Soeren Sonnenburg <sonne@debian.org>
> > > Date		: 2009-11-14 10:16 (3 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=125819380206800&w=4
> > 
> > This looks like an input core problem, as the evdev module was just
> > loaded and died.
> > 
> > Any input developers have any ideas?
> > 
> 
> 
> Hmm, evdev does:
> 
> 	dev_set_name(&evdev->dev, "event%d", minor);
> 
> Not sure how it can go wrong...

Anything I should/could do to narrow it down a bit (apart from
bisecting?).

Soeren
-- 
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962
