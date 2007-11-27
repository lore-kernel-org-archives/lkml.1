Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbXK0W6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbXK0W6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbXK0W6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:58:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777AbXK0W6Q (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:58:16 -0500
Date: Tue, 27 Nov 2007 14:57:43 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: pomac@vapor.com
Cc: Linux-kernel <Linux-kernel@vger.kernel.org>
Subject: Re: [SKY2] Problems (2.6.24-rc3-git1)
Message-ID: <20071127145743.1e41127f@freepuppy.rosehill>
In-Reply-To: <1196203222.27041.0.camel@localhost>
References: <1191372129.26233.12.camel@localhost>
	<20071002180209.47c350a3@freepuppy.rosehill>
	<1191375274.26233.17.camel@localhost>
	<20071002215914.13d1e8cf@freepuppy.rosehill>
	<1196203222.27041.0.camel@localhost>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 23:40:22 +0100
Ian Kumlien <pomac@vapor.com> wrote:

> [Repost, no reply has been recived]
> 
> Hi,
> 
> A little while ago, something went horribly wrong.
> 
> I could still use my mouse and the desktop was still alive more or
> less... everything using networking was dead AND the keyboard was
> dead... So i composed commands using existing text on the screen.
> 
> The device:
> sky2 0000:02:00.0: v1.20 addr 0xdbffc000 irq 17 Yukon-EC (0xb6) rev 2
> sky2 0000:02:00.0: PCI Express Advanced Error Reporting not configured or MMCONFIG problem?
> sky2 0000:02:00.0: No interrupt generated using MSI, switching to INTx mode.
> sky2 eth0: addr 00:15:f2:aa:8b:3e

The recovery logic for hung FIFO no longer works in 2.6.24-rc1+, I'm looking
into it.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
