Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYHSOc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYHSOc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYHSOcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:32:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51678 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750788AbYHSOcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:32:20 -0400
Date: Tue, 19 Aug 2008 10:32:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       <James.Bottomley@HansenPartnership.com>, <teheo@novell.com>,
       <oneukum@suse.de>
Subject: Re: Power management for SCSI
In-Reply-To: <20080819073839.GA8726@atrey.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.44L0.0808191027070.2669-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, Pavel Machek wrote:

> Would it make sense to split the patches into "autosuspend for SCSI
> devices" and "autosuspend for SCSI controllers" for easier
> review/merge? I guess I'll start with the devices, they seem easier...

It really should be split up differently.  The topics of interest are:

	idle detection for SCSI devices,

	autosuspend for SCSI targets and its relation to suspend
	for SCSI devices,

	passing suspend & resume notifications to the transport class,

	adding a USB transport class so that usb-storage can respond
	to those notifications,

	modifying other transport classes as needed so that the LLDs
	can power-down links or host adapters.

I think that covers it.  Oliver may have some additional suggestions.

Alan Stern

