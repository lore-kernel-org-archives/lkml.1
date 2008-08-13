Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYHMPX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYHMPX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYHMPXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:23:50 -0400
Received: from mail.suse.de ([195.135.220.2]:44092 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYHMPXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:23:49 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Power management for SCSI
Date: Wed, 13 Aug 2008 17:24:51 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       James.Bottomley@hansenpartnership.com, teheo@novell.com
References: <Pine.LNX.4.44L0.0808131051330.2455-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808131051330.2455-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808131724.52461.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 13 August 2008 16:59:23 schrieb Alan Stern:
> This is a good question.  Most USB mass-storage devices do not act as a
> true SCSI bus, but I believe there are a few non-standard ones that do
> -- the USB device really contains a SCSI host and arbitrary SCSI

OK, but does it make sense to have SCSI autosuspend? Or should autosuspend
operate on the bus the _host_ is connected to (usb, pci, ...)?

	Regards
		Oliver

