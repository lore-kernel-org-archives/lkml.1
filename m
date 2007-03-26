Return-Path: <linux-kernel-owner+w=401wt.eu-S933408AbXCZWeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbXCZWeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933564AbXCZWeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:34:01 -0400
Received: from eazy.amigager.de ([213.239.192.238]:40872 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408AbXCZWeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:34:00 -0400
Date: Tue, 27 Mar 2007 00:33:59 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod doesn't work
Message-ID: <20070326223359.GA4942@dose.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oneukum@suse.de>,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070326204744.GA24762@dose.home.local> <Pine.LNX.4.44L0.0703261712340.7079-100000@iolanthe.rowland.org> <20070326212614.GA15856@dose.home.local> <20070326222124.GA2873@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326222124.GA2873@dose.home.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 00:21:24 +0200, Tino Keitel wrote:

[...]

> this is the bisect result:
> 
> $ git bisect good
> 1d619f128ba911cd3e6d6ad3475f146eb92f5c27 is first bad commit
> commit 1d619f128ba911cd3e6d6ad3475f146eb92f5c27

I just tested 2.6.21-rc5 with this commit reverted and the iPod was
regognized with CONFIG_USB_SUSPEND enabled.

Regards,
Tino
