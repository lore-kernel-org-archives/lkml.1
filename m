Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYDBPJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYDBPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYDBPJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:09:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55813 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755571AbYDBPJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:09:00 -0400
Date: Wed, 2 Apr 2008 11:08:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@suse.cz>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, <jikos@suse.cz>,
       <linux-usb@vger.kernel.org>
Subject: Re: 2.6.25-rc7:  Ugh.
In-Reply-To: <47F39A80.9090201@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0804021106320.6272-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Mark Lord wrote:

> I'll be installing -rc8 today, and see what happens there.

Have you tried testing with all the USB drivers present except 
ehci-hcd?  So far all the indicators are that it is the source of the 
problem.

Also, check out the thread on LKML started by Tino Keitel.  He had
similar problems and found that reverting commit
e82cc1288fa57857c6af8c57f3d07096d4bcd9d9 fixed them.

Alan Stern

