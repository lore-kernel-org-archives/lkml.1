Return-Path: <linux-kernel-owner+w=401wt.eu-S933464AbXHFPW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbXHFPW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764472AbXHFPWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:22:51 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4527 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764390AbXHFPWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:22:50 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: RE: MODULE_LICENSE usage
Date: Mon, 6 Aug 2007 08:22:48 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEOJFOAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 06 Aug 2007 08:23:24 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 06 Aug 2007 08:23:24 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm working on a driver for an ADSL modem which requires the use of a
> binary library from the chipset manufacturer.  All my source code is
> GPL, so that others are free to distribute and modify the driver.
> After asking the FSF for advice and working through their FAQ, I've
> given permission for the binary library file to be used with the GPL
> source code and be re-distributed with it.
>
> I would like to know if I'm permitted to use
> MODULE_LICENSE("GPL") in my module.

I don't see any reason you cannot include the line 'MODULE_LICENSE("GPL")'
in the source code for your module so long as that source code is not a
derivative work of the binary. Whether or not you can distribute the
resulting binary is, however, a complex legal question.

> Additionally, I'm unsure of what is the meaning of
>
> "GPL and additional rights"     [GNU Public License v2 rights and more]
>
> Is it correct to say that my driver is licensed under GPL with
> additional rights to use the binary library file?

No. The "additional right" to use the binary library file is not a right
under which your driver is licensed, so there are no additional rights to
your driver. The binary library itself is offered under rights much less
than the GPL.

What exactly is the license under which the binary is offered? If it's "may
be used with your driver" then you may have some interesting GPL issues when
people want to modify your driver and continue to use the binary firmware
with it.

Does this "binary library" actually run on the host computer? Or is it
firmware that runs on the modem only? Does it actually link in to the
driver?

DS


