Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab0BCWho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:37:44 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33890 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab0BCWhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:37:40 -0500
Date: Wed, 3 Feb 2010 22:37:37 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
	writes" causes gobi_loader to hang
Message-ID: <20100203223737.GA2578@srcf.ucam.org>
References: <20100117025535.GB7045@srcf.ucam.org> <201001191420.29652.oliver@neukum.org> <20100203164659.GA26807@srcf.ucam.org> <201002031821.39532.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002031821.39532.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 06:21:39PM +0100, Oliver Neukum wrote:
> Am Mittwoch, 3. Februar 2010 17:46:59 schrieb Matthew Garrett:
> > > If the FIFO is full we can do nothing. Please try the attached patch.
> > 
> > Doesn't help, I'm afraid. Does anyone have any idea why the change to 
> > use kfifo would cause this?
> 
> The logic seems sound. That is unless the kfifo code is acting up.
> Could you printk the value kfifo_len returns in usb_serial_generic_write_start()?

kfifo_len is 4096 when it gets into the fifo_full situation.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
