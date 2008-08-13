Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYHMQUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYHMQUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYHMQUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:20:30 -0400
Received: from ns1.suse.de ([195.135.220.2]:50233 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYHMQU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:20:29 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Power management for SCSI
Date: Wed, 13 Aug 2008 18:21:29 +0200
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>,
       James.Bottomley@hansenpartnership.com, Pavel Machek <pavel@suse.cz>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com
References: <Pine.LNX.4.44L0.0808131138110.2151-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808131138110.2151-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808131821.30564.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 13 August 2008 17:44:46 schrieb Alan Stern:
> > All children that are USB must be powered down. We know in fact that most
> > drives don't care that the device is suspended. The problem was drive
> > enclosures that cut power upon suspension losing cached data.
> 
> You misunderstood my question.  Are there SCSI transports other than
> USB sharing the requirement that all child devices must be suspended
> before the link can be powered down?

I dispute that USB in general has this property. Some storage devices
need their caches flushed. USB itself is perfectly happy with autosuspending
the storage device (host) without telling the disks (devices)

You could even argue that these storage devices violate the USB spec.

	Regards
		Oliver

