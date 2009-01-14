Return-Path: <linux-kernel-owner+w=401wt.eu-S1763039AbZANO55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763039AbZANO55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760781AbZANO5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:57:19 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43941 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759444AbZANO5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:57:18 -0500
Date: Wed, 14 Jan 2009 09:57:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: =?ISO-8859-1?Q?Ji=5F=5F=ED?= Burda <jburda@email.cz>,
       <linux-usb@vger.kernel.org>, <greg@kroah.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: Nokia 5310 mass-storage not mounting in kernel
 2.6.28
In-Reply-To: <20090113153704.2ca5174d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0901140955420.2587-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009, Andrew Morton wrote:

> > From: Jiri Burda <jburda@email.cz>	
> > 
> > Nokia 5310 mobile with firmware revision 8.32 does not mount as usb mass-storage in kernel 2.6.28 and previous.
> > This patch solves this problem by increasing firmware revision in drivers/usb/storage/unusual_device.h from 0x0701 to 0x0832.
> > This bug is recorded in kernel bugzilla as 12367.

> The 5310 entry seems to have been removed in 2.6.29-rc1.

Indeed, as Greg mentioned we are now using a generic scheme for Nokia 
devices.

Jiri, can you try running 2.6.29-rc1 to see whether it's okay already?

Alan Stern

