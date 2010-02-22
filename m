Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0BVVYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:24:08 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38037 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab0BVVYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:24:02 -0500
Date: Mon, 22 Feb 2010 21:23:51 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Anssi Hannula <anssi.hannula@iki.fi>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, dvomlehn@cisco.com, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
	writes" causes gobi_loader to hang
Message-ID: <20100222212351.GA29637@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1002221408200.1251-100000@iolanthe.rowland.org> <201002222124.27777.anssi.hannula@iki.fi> <20100222212458.69249775@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222212458.69249775@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 09:24:58PM +0000, Alan Cox wrote:

> If the device wants exactly bounded packets then for the firmware loader
> tty is probably the wrong interface.

Upstream's driver is tty based, so it's not really clear what the 
hardware expects.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
