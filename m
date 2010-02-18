Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab0BRG4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 01:56:19 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:54113 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0BRG4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 01:56:18 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Subject: Re: USB mass storage and ARM cache coherency
Date: Thu, 18 Feb 2010 07:56:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF84D1@dbde02.ent.ti.com> <Pine.LNX.4.44L0.1002171201190.1913-100000@iolanthe.rowland.org> <5A47E75E594F054BAF48C5E4FC4B92AB03216236D6@dbde02.ent.ti.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB03216236D6@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002180756.14100.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 17. Februar 2010 21:30:24 schrieb Gadiyar, Anand:
> > Why do you skip mapping the setup packet but not the data packet?
> > 
> 
> I think that's oversight. For this controller, we need to skip mapping
> all buffers used to do transfers on EP0, which is all control transfers.

One thing more. Do you have an issue with EP 0 only or all control
endpoints? EP 0 must be control, but devices are within spec if they
have multiple control endpoints provided EP 0 is control.

	Regards
		Oliver
