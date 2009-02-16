Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZBPWk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZBPWk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbZBPWkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:40:13 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1797 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751262AbZBPWkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:40:12 -0500
Date: Mon, 16 Feb 2009 17:40:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Arjan van de Ven <arjan@infradead.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
In-Reply-To: <200902162312.50556.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0902161736210.21117-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009, Rafael J. Wysocki wrote:

> OK, so I think there are two things that user space may be allowed to do as
> far as putting devices into low power states is concerned:
> * disable/enable the automatic power management of the device (provided that
>   the driver supports the automatic PM)

Set the automatic PM parameters (idle timeout, state to go to, etc.).  
And disabling automatic PM altogether (effectively the same as setting
the idle timeout to infinity).

> * check what power states devices are in.

What about situations where we want to distinguish between the power 
state of the device itself and the power state of the link?  For a disk 
drive we may want to power the link on and off quite a lot, as that 
has low latency, but spinning the disk up and down takes a long time 
and so should have a longer idle-time value.

Alan Stern

