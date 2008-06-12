Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbYFLUFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbYFLUFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbYFLUFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:05:16 -0400
Received: from senator.holtmann.net ([87.106.208.187]:33970 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbYFLUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:05:12 -0400
Subject: Re: [PATCH] [RESEND] fix HID quirks for aluminium apple wireless
	keyboards
From: Marcel Holtmann <marcel@holtmann.org>
To: Paul Collins <paul@burly.ondioline.org>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <874p7ylsj0.fsf@burly.wgtn.ondioline.org>
References: <87iqweltzo.fsf@burly.wgtn.ondioline.org>
	 <874p7ylsj0.fsf@burly.wgtn.ondioline.org>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 22:08:09 +0200
Message-Id: <1213301289.17870.72.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> I noticed that the quirks for Bluetooth Apple keyboards seem to have
> been incorrectly added to the USB HID, thus rendering them ineffective.
> Here is a patch that moves them to the Bluetooth HID.  With this patch
> applied the Fn key on my Apple wireless keyboard now works as expected.
> 
> I also took the liberty of adding defines for the vendor and for the
> existing Mighty Mouse quirk.

I prefer not to do this. I don't see any benefit or readability coming
out of it. Leave it as it is. Add the numeric ids and then a line on top
of it describing the devices.

Regards

Marcel


