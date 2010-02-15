Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0BONI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 08:08:27 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:46337 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab0BONIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 08:08:25 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Mon, 15 Feb 2010 14:08:27 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002122148050.13658-100000@netrider.rowland.org> <201002131535.42116.anssi.hannula@iki.fi> <201002132101.55079.anssi.hannula@iki.fi>
In-Reply-To: <201002132101.55079.anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002151408.27146.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 13. Februar 2010 20:01:54 schrieb Anssi Hannula:
> > I'll get back to this later today, including testing with mdelay in
> > port_release with the extra sleep calls in gobi_loader.
> 
> port_release is only called when the serial device is removed, so this has no 
> effect here.

But something must kill your last URB.
You are not using autosuspend are you? Can load usbserial with "debug=1"?

	Regards
		Oliver
