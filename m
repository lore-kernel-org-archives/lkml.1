Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbYHNOH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbYHNOH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYHNOHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:07:13 -0400
Received: from ns2.suse.de ([195.135.220.15]:58848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYHNOHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:07:11 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [linux-pm] Power management for SCSI
Date: Thu, 14 Aug 2008 16:08:12 +0200
User-Agent: KMail/1.9.9
Cc: linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>,
       James.Bottomley@hansenpartnership.com,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com
References: <Pine.LNX.4.44L0.0808131138110.2151-100000@iolanthe.rowland.org> <200808131821.30564.oneukum@suse.de> <20080814135021.GE2262@elf.ucw.cz>
In-Reply-To: <20080814135021.GE2262@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808141608.13431.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 14 August 2008 15:50:21 schrieb Pavel Machek:
> On Wed 2008-08-13 18:21:29, Oliver Neukum wrote:
> > Am Mittwoch 13 August 2008 17:44:46 schrieb Alan Stern:
> > > > All children that are USB must be powered down. We know in fact that most
> > > > drives don't care that the device is suspended. The problem was drive
> > > > enclosures that cut power upon suspension losing cached data.
> > > 
> > > You misunderstood my question.  Are there SCSI transports other than
> > > USB sharing the requirement that all child devices must be suspended
> > > before the link can be powered down?
> > 
> > I dispute that USB in general has this property. Some storage devices
> > need their caches flushed. USB itself is perfectly happy with autosuspending
> > the storage device (host) without telling the disks (devices)
> > 
> > You could even argue that these storage devices violate the USB spec.
> 
> Hmm... but suspended devices have very little power budget, right?
> 
> So unless you have external power supply (2.5" frames generally
> don't), you can't really suspend and stay spinned up...
> 

True, but the spec says that no state shall be lost.

I don't really argue against flushing the caches. But I cannot that this would
demand that we should implement autopsuspend for SCSI. It seems like
overengineering to me.

	Regards
		Oliver

