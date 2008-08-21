Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYHUG1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYHUG1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYHUG07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:26:59 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:57807 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbYHUG06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:26:58 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: amruth_pv@yahoo.com
Subject: Re: USB Serial device disconnect causes IRQ disable
Date: Thu, 21 Aug 2008 08:28:07 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <599889.19115.qm@web45210.mail.sp1.yahoo.com>
In-Reply-To: <599889.19115.qm@web45210.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210828.08182.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 21 August 2008 08:18:38 schrieb amruth:
> > OK, do you have any other USB device on the same bus as
> > your serial
> > converter?
> I have one USB storage flash key device nothing else.
> The problem is coming from serial convertor and my driver did not handle interrupts.

But is this key on the same bus? What does "lsusb -t" say?
Your driver is USB, isn't it? It cannot fail to handle PCI interrupts.
There may be something fishy here.

	Regards
		Oliver
