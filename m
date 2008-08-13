Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbYHMUit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbYHMUit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYHMUik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:38:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57386 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752470AbYHMUik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:38:40 -0400
Date: Wed, 13 Aug 2008 16:38:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Leisner, Martin" <Martin.Leisner@xerox.com>
cc: Oliver Neukum <oneukum@suse.de>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, <teheo@novell.com>,
       <James.Bottomley@hansenpartnership.com>, Pavel Machek <pavel@suse.cz>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: RE: [linux-pm] Power management for SCSI
In-Reply-To: <556445368AFA1C438794ABDA8901891C094876DA@USA0300MS03.na.xerox.net>
Message-ID: <Pine.LNX.4.44L0.0808131636400.2144-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, Leisner, Martin wrote:

> Regarding these scsi suspend patches, there's a general
> problem to drop power on disk devices on a running system.
> I discussed it in:
> 
> http://www.gossamer-threads.com/lists/linux/kernel/811598

There's a much worse problem which that thread completely ignored:

When you turn off power to a disk device, to the system it looks like a 
hot-unplug event.  Any mounted filesystems or memory mappings on that 
disk will be lost.

Alan Stern

