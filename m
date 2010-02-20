Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0BTST2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 13:19:28 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:33979 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab0BTST0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 13:19:26 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Sat, 20 Feb 2010 19:19:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002122148050.13658-100000@netrider.rowland.org> <201002151408.27146.oliver@neukum.org> <201002201803.41594.anssi.hannula@iki.fi>
In-Reply-To: <201002201803.41594.anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002201919.10674.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 20. Februar 2010 17:03:41 schrieb Anssi Hannula:
> > But something must kill your last URB.
> > You are not using autosuspend are you?
> 
> Don't know, usbcore has autosuspend=2 and the gobi device has autosuspend=2 
> and supports_autosuspend=1.

What is the content of "level"?

> > Can load usbserial with "debug=1"?
> 
> Here's the end of dmesg when running with that option:
> http://stuff.onse.fi/gobi2000/gobi-regression.dmesg.log
> 
> This is again with the gobi_loader with extra sleep added in the beginning. 
> Otherwise it hangs (which is the actual original problem).

That log makes sure that the final cancellation comes from closing
the file. Is that a log of a working run?

	Regards
		Oliver
