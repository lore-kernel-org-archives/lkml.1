Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYJCTnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYJCTnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYJCTmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:42:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58317 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752880AbYJCTmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:42:33 -0400
Date: Fri, 3 Oct 2008 21:40:40 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Jeffrey W. Baker" <jwbaker@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: Put unused PCI devices in D3
Message-ID: <20081003194040.GC1497@ucw.cz>
References: <1222719064.19236.129.camel@squeak.gghcwest.com> <20080930000923.GA29775@srcf.ucam.org> <1222736147.21516.12.camel@stinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222736147.21516.12.camel@stinkpad>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > * If the device is a bridge or hub with no downstream device
> > 
> > Potential problems with hotplugging? But sure, this kind of thing is 
> > being implemented in USB and SCSI.
> > 
> > > * Whenever userspace requests D3 via sysfs
> > 
> > This functionality was explicitly removed a few years back.
> 
> I sure would like to have it back, if only just for experimentation.

Feel free to find it and reapply for your experiments. The file was in
sysfs was called power/state, just grep git logs for that.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
