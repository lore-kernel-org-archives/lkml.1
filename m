Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab0BBLsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:48:15 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:53685 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab0BBLsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:48:14 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: USB mass storage and ARM cache coherency
Date: Tue, 2 Feb 2010 12:48:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
References: <20100129185434.GH19501@one-eyed-alien.net> <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002021248.10994.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 1. Februar 2010 18:29:14 schrieb Catalin Marinas:
> +       if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) == PIPE_BULK) {
> +               void *ptr;
> +               for (ptr = urb->transfer_buffer;
> +                    ptr < urb->transfer_buffer + urb->transfer_buffer_length;
> +                    ptr += PAGE_SIZE)
> +                       flush_dcache_page(virt_to_page(ptr));

Is it correct to limit this to BULK pipes?

	Regards
		Oliver

