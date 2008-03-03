Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbYCCRju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbYCCRju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762578AbYCCRcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:32:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:59300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760757AbYCCRcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:32:45 -0500
Date: Mon, 3 Mar 2008 18:32:38 +0100
From: Karsten Keil <kkeil@suse.de>
To: Tilman Schmidt <tilman@imap.cc>
Cc: kkeil@suse.de, Jeff Garzik <jeff@garzik.org>, Greg KH <greg@kroah.com>,
       Gregory Nietsky <gregory@networksentry.co.za>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Simon Richter <sjr@debian.org>, isdn4linux@listserv.isdn4linux.de,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Plans for mISDN?
Message-ID: <20080303173238.GA18880@pingi.kke.suse.de>
Mail-Followup-To: Tilman Schmidt <tilman@imap.cc>, kkeil@suse.de,
	Jeff Garzik <jeff@garzik.org>, Greg KH <greg@kroah.com>,
	Gregory Nietsky <gregory@networksentry.co.za>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Simon Richter <sjr@debian.org>, isdn4linux@listserv.isdn4linux.de,
	Sam Ravnborg <sam@ravnborg.org>
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc> <47BD5360.5070706@debian.org> <20080222120412.GA11916@pingi.kke.suse.de> <47C2D312.60100@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C2D312.60100@imap.cc>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 03:39:14PM +0100, Tilman Schmidt wrote:
> On 22.02.2008 13:04, Karsten Keil wrote:
> >These design issues are fixed in the new mISDN socket branch.
> >The old mISDN design was too complicated because it allow access to
> >every layer and build the ISDN stack dynamically, both feature were never
> >needed in practice and contain many race conditions.
> >The new design only has one core module and hardware specific modules
> >with a very simple interface.
> 
> Great news. I pulled your socket branch and am currently trying to
> find my way through one of the two hardware drivers available there
> and abstract away from the PCI card specific parts.
> Is there a design document available? Or will there be some non-PCI
> driver soon, perhaps even one for a USB device? That would be
> immensely helpful.
> 

It will, Martin will work on it soon.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
