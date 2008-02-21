Return-Path: <linux-kernel-owner+w=401wt.eu-S935267AbYBUWiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935267AbYBUWiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764422AbYBUWhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:37:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43886 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759303AbYBUWhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:37:50 -0500
Date: Thu, 21 Feb 2008 17:37:48 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>
Subject: Re: power_state: remove it from usb
In-Reply-To: <20080221221950.GA25977@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0802211737002.4990-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008, Pavel Machek wrote:

> > Unfortunately some of the things you changed turn out not to be 
> > write-only.  (You also missed a usage of power.power_state in a 
> > comment!)  
> 
> I might have missed comments, but where I missed read? It compiled
> after I removed the field from the core...?

Grep for power_state in drivers/usb/host/*.c.

Alan Stern

