Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbZIOTrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbZIOTrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758039AbZIOTrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:47:05 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:56179 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610AbZIOTrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:47:04 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Andreas Mohr <andi@lisas.de>
Subject: Re: usb autosuspend is history after S2R (also on 2.6.31; UVC?)
Date: Tue, 15 Sep 2009 21:48:28 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, laurent.pinchart@skynet.be,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090915185145.GA31490@rhlx01.hs-esslingen.de>
In-Reply-To: <20090915185145.GA31490@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909152148.29662.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 15. September 2009 20:51:45 schrieb Andreas Mohr:

> So, does the uvc driver need a bit of handholding here?
> It likely shouldn't simply forget about its autosuspend status after
> resume...

Can you please provide what you get when you read the "level" file
of the device's power directory?

Secondly, please verify, that it works before the STR cycle and post
a syslog of a suspend/resume cycle with CONFIG_USB_DEBUG and
only this device attached if possible. Thirdly, please verify that only
uvc is affected.

> Or would Matthew's uvc autosuspend patch
> http://osdir.com/ml/fedora-extras-commits/2009-07/msg06079.html
> help here?

Please test it. It shouldn't work, but if it works there's a fundamental
flaw.

	Regards
		Oliver

