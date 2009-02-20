Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZBTS04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZBTS04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZBTS0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:26:47 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58857 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZBTS0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:26:46 -0500
Date: Fri, 20 Feb 2009 18:26:09 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090220182609.GA3289@srcf.ucam.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org> <20090220182213.GA1681@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220182213.GA1681@ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 07:22:15PM +0100, Pavel Machek wrote:
>  On Mon 2009-02-16 23:23:30, Matthew Garrett wrote:
> > On Tue, Feb 17, 2009 at 12:19:38AM +0100, Rafael J. Wysocki wrote:
> > 
> > > This, again, seems to be a bit x86-centric. :-)  The Android people are telling
> > > us that on the hardware they deal with it does make sense to put the entire
> > > system to sleep even for relatively short periods of time, since the latencies
> > > involved are not too bad.
> > 
> > Arve said that the power state was equivalent in idle and suspend, but 
> 
> ...for Arve's hardware. Not all embedded systems are like that, and
> OLPC / PCs are definitely not like that.

And PCs have enough latency over suspend/resume that we can't do it 
automatically in a non-intrusive manner anyway, so runtime pm is more 
interesting there as well.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
