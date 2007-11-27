Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbXK0J26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbXK0J26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbXK0J2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:28:34 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:50329 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbXK0J2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:28:33 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "ming lei" <tom.leiming@gmail.com>
Subject: Re: Small System Paging Problem - OOM-killer goes nuts
Date: Tue, 27 Nov 2007 10:29:03 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Josh Goldsmith" <joshin@hotmail.com>, linux-kernel@vger.kernel.org
References: <BLU103-DAV550703C13BE5EF0DDF51AD6740@phx.gbl> <d82e647a0711261717s12fdfd13q4961294cd957d7af@mail.gmail.com>
In-Reply-To: <d82e647a0711261717s12fdfd13q4961294cd957d7af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711271029.04034.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 27 November 2007 schrieb ming lei:
> It seems  oom happenes when VM(page frame reclaim) try to reclaim much
> more memory by writing back dirty pages, but  there is not enough ram
> for usb disk  related driver to finish the writeback operation. (usb
> disk related driver: scsi_mod, usb mass storage, usbcore and uhci or
> ehci )

As far as I can tell, the problem arises because usb-storage's kernel
thread does not run with PF_MEMALLOC and cannot dip into the reserves.

	Regards
		Oliver

