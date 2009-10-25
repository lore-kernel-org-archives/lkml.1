Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbZJYWFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbZJYWFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 18:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZJYWFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 18:05:55 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:60094 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbZJYWFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 18:05:54 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Bart Hartgers <bart.hartgers@gmail.com>
Subject: Re: [PATCH 3/7] ark3116: (3rd try) Replace cmget
Date: Sun, 25 Oct 2009 23:08:02 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091025175057.270011110@gmail.com> <200910252052.09845.oliver@neukum.org> <7eb6a4d80910251256w4ad8a77dg5a24618657b77a58@mail.gmail.com>
In-Reply-To: <7eb6a4d80910251256w4ad8a77dg5a24618657b77a58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910252308.02695.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 25. Oktober 2009 20:56:36 schrieb Bart Hartgers:
> I don't think so. The two values are not really related.
>
> These are two separate things: mcr (modem control reg) is ultimately
> changed by whatever has the serial port open, msr (modem status
> register) represents the status of the handshaking lines, and is
> changed (via the interrupt urb callback) by hardware.

If so, why is mcr of the type atomic_t ?

	Regards
		Oliver

