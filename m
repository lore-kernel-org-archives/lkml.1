Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZBPW4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZBPW4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZBPW4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:56:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:37602 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbZBPW4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:56:06 -0500
Date: Mon, 16 Feb 2009 14:55:59 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216145559.5412b909@infradead.org>
In-Reply-To: <20090216225116.GG1370@ucw.cz>
References: <200902160010.16955.rjw@sisk.pl>
	<20090215164456.34aef7e8@infradead.org>
	<200902162248.34287.rjw@sisk.pl>
	<20090216225116.GG1370@ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 23:51:16 +0100
Pavel Machek <pavel@suse.cz> wrote:

> Hi!
> 
> > > Userland should never ever control the state of a device like this
> > > directly. It should do so by a) closing the device and b) setting
> > > latency / functional requirements.
> > 
> > The user, however, may want to forcibly put a device into a low
> > power state without stopping all of the applications that depend on
> > it (eg. have it open). Do you think that we shouldn't allow users
> > to do such things?
> 
> I don't think we should do this... of you want device to be powered
> down, just don't keep it open. revoke should be enough :-).
> 
> ...one execption here is the disk driver; unmounting filesystems to
> let the disk spin down is probably too heavy.

but spin down happens on non-activity ;)
it's more a slumber than a power down



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
