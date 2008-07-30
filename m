Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbYG3OIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbYG3OIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYG3OIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:08:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54961 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750887AbYG3OIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:08:45 -0400
Date: Wed, 30 Jul 2008 10:08:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [patch 5/3] fastboot: sync the async execution before late_initcall
 and move level 6s (sync) first
In-Reply-To: <488F9AE3.8040207@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0807301006560.2584-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008, Simon Arlott wrote:

> It doesn't appear to be possible to init multiple PCI devices at once... 
> I haven't looked into what is doing it exactly but presumably there's a 
> lock being held over the whole device probe process.
> 
> The speedup from usb seems to be primarily from initialising devices in 
> the background... perhaps there's some way to do that without doing hcd 
> init from a second thread?

You could provide useful details by booting a kernel with
CONFIG_USB_DEBUG enabled.

The USB stack _already_ initializes USB devices (i.e., not host
controllers) in a separate thread.

Alan Stern

