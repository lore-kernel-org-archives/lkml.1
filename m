Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0BUVh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:37:58 -0500
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:50637 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab0BUVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:37:57 -0500
X-Spam-Flag: NO
X-Spam-Score: 0
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Sun, 21 Feb 2010 23:37:53 +0200
User-Agent: KMail/1.13.0 (Linux/2.6.33-desktop-0.rc8.1mnb; KDE/4.4.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002122148050.13658-100000@netrider.rowland.org> <201002201803.41594.anssi.hannula@iki.fi> <201002201919.10674.oliver@neukum.org>
In-Reply-To: <201002201919.10674.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002212337.53470.anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On lauantai 20 helmikuu 2010 20:19:10 Oliver Neukum wrote:
> Am Samstag, 20. Februar 2010 17:03:41 schrieb Anssi Hannula:
> > > But something must kill your last URB.
> > > You are not using autosuspend are you?
> > 
> > Don't know, usbcore has autosuspend=2 and the gobi device has
> > autosuspend=2 and supports_autosuspend=1.
> 
> What is the content of "level"?

"on"

> > > Can load usbserial with "debug=1"?
> > 
> > Here's the end of dmesg when running with that option:
> > http://stuff.onse.fi/gobi2000/gobi-regression.dmesg.log
> > 
> > This is again with the gobi_loader with extra sleep added in the
> > beginning. Otherwise it hangs (which is the actual original problem).
> 
> That log makes sure that the final cancellation comes from closing
> the file. Is that a log of a working run?

No.

-- 
Anssi Hannula
