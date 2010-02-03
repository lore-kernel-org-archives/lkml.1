Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab0BCRVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:21:50 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:51518 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab0BCRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:21:48 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Wed, 3 Feb 2010 18:21:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100117025535.GB7045@srcf.ucam.org> <201001191420.29652.oliver@neukum.org> <20100203164659.GA26807@srcf.ucam.org>
In-Reply-To: <20100203164659.GA26807@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002031821.39532.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 3. Februar 2010 17:46:59 schrieb Matthew Garrett:
> > If the FIFO is full we can do nothing. Please try the attached patch.
> 
> Doesn't help, I'm afraid. Does anyone have any idea why the change to 
> use kfifo would cause this?

The logic seems sound. That is unless the kfifo code is acting up.
Could you printk the value kfifo_len returns in usb_serial_generic_write_start()?

	Regards
		Oliver
