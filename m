Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZBPWvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZBPWvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZBPWva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:51:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43843 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbZBPWv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:51:29 -0500
Date: Mon, 16 Feb 2009 23:51:16 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>,
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
Message-ID: <20090216225116.GG1370@ucw.cz>
References: <200902160010.16955.rjw@sisk.pl> <20090215164456.34aef7e8@infradead.org> <200902162248.34287.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902162248.34287.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Userland should never ever control the state of a device like this
> > directly. It should do so by a) closing the device and b) setting
> > latency / functional requirements.
> 
> The user, however, may want to forcibly put a device into a low power state
> without stopping all of the applications that depend on it (eg. have it open).
> Do you think that we shouldn't allow users to do such things?

I don't think we should do this... of you want device to be powered
down, just don't keep it open. revoke should be enough :-).

...one execption here is the disk driver; unmounting filesystems to
let the disk spin down is probably too heavy.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
