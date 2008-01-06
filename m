Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbYAFW0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbYAFW0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbYAFW0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:26:19 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2404 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758741AbYAFW0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:26:18 -0500
Date: Sun, 6 Jan 2008 17:26:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Pavel Machek <pavel@ucw.cz>, Raymano Garibaldi <raymano@faunos.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [FEATURE REQUEST] Transparent hot plugging of
 root file system on portable storage devices.
In-Reply-To: <200801062159.46481.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0801061722400.19222-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008, Oliver Neukum wrote:

> Am Sonntag 06 Januar 2008 schrieb Alan Stern:
> > What about people who want to suspend to RAM instead of hibernating and
> > _do_ want to unplug the USB device containing their root filesystem
> > while the machine is asleep?  In this case we will _know_ that the
> > power session has been interrupted, but USB Persist won't activate
> > because the host controller never lost power.
> 
> Would it be hard to force the persist feature on for a replugged device?

Right now the persist feature is enabled by a per-device boolean flag.  
In theory the flag could accept 3 values: off, on if power was lost,
or on for any resume transition.  This would not be a hard change.

Alan Stern

