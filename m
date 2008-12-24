Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbYLXCpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbYLXCpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 21:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYLXCpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 21:45:12 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3607 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751753AbYLXCpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 21:45:11 -0500
Date: Tue, 23 Dec 2008 21:45:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       <linux-usb@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: Driver for Freescale QUICC Engine USB Host Controller
In-Reply-To: <20081223210322.GA2802@oksana.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.44L0.0812232140400.8076-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2008, Anton Vorontsov wrote:

> This patch adds support for the FHCI USB controller, as found
> in the Freescale MPC836x and MPC832x processors. It can support
> Full or Low speed modes.
> 
> Quite a lot the hardware is doing by itself (SOF generation, CRC
> generation and checking), though scheduling and retransmission is on
> software's shoulders.
> 
> This controller does not integrate the root hub, so this driver also
> fakes one-port hub. External hub is required to support more than
> one device.

It looks like the kernel this was written for is several versions out 
of date.  The driver is missing some critical calls to functions like 
usb_hcd_link_urb_to_ep().

Alan Stern

