Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbZF3HWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbZF3HWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 03:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZF3HVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 03:21:51 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:47229 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbZF3HVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 03:21:51 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Arseniy Lartsev <ars3n@yandex.ru>
Subject: Re: PROBLEM: USB ACM device does not work
Date: Tue, 30 Jun 2009 09:22:04 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <200906282229.35713.ars3n@yandex.ru> <200906291507.45281.oliver@neukum.org> <200906291735.23024.ars3n@yandex.ru>
In-Reply-To: <200906291735.23024.ars3n@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906300922.04257.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. Juni 2009 15:35:15 schrieb Arseniy Lartsev:
> On Monday 29 June 2009 17:07:44 Oliver Neukum wrote:
> > Please printk xfertype in the error case of usb_submit_urb()
>
> It equals USB_ENDPOINT_XFER_INT.

Yet, your device shows bulk endpoints. Please enable DEBUG in cdc-acm.c
and recompile with CONFIG_USB_DEBUG.

	Regards
		Oliver

