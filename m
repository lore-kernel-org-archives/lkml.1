Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab0BYDso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:48:44 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:35773 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758904Ab0BYDsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:48:43 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: USB mass storage and ARM cache coherency
Date: Thu, 25 Feb 2010 04:48:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Greg KH <greg@kroah.com>, "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Sebastian Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Ming Lei <tom.leiming@gmail.com>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>
References: <1266445892.16346.306.camel@pasglop> <201002240816.10178.oliver@neukum.org> <1267045954.23523.1692.camel@pasglop>
In-Reply-To: <1267045954.23523.1692.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002250448.17866.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. Februar 2010 22:12:34 schrieb Benjamin Herrenschmidt:
> On Wed, 2010-02-24 at 08:16 +0100, Oliver Neukum wrote:
> > I don't know. The issue seems quite complex. It would seem better to
> > centralize it as far as practical. Do you have a wrapper drivers could
> > call?
> 
> flush_dcache_page() ? :-)

Will this do anything on arches that don't need it?
Secondly, can we have a wrapper that you can pass a pointer and an
offset?
 
> Now, the subsystem might be the one to know whether something is mapped
> into userspace or not (v4l in our case) in which case a wrapper could be
> created.

If possible, I'd like to centralize this. Drivers are likely to get this wrong.

	Regards
		Oliver
