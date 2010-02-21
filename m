Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0BUXNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 18:13:40 -0500
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:38895 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753258Ab0BUXNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 18:13:39 -0500
X-Spam-Flag: NO
X-Spam-Score: 0
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Mon, 22 Feb 2010 01:13:35 +0200
User-Agent: KMail/1.13.0 (Linux/2.6.33-desktop-0.rc8.1mnb; KDE/4.4.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002211627430.32083-100000@netrider.rowland.org> <201002212312.36320.oliver@neukum.org> <201002220106.36476.anssi.hannula@iki.fi>
In-Reply-To: <201002220106.36476.anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002220113.35941.anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On maanantai 22 helmikuu 2010 01:06:36 Anssi Hannula wrote:
> On maanantai 22 helmikuu 2010 00:12:36 Oliver Neukum wrote:
> > Am Sonntag, 21. Februar 2010 22:42:12 schrieb Anssi Hannula:
> > > And of course this doesn't explain why it hangs (and the WARNING) if I
> > > remove the sleep calls I added in gobi_loader.
> > 
> > Please tell us where you put a delay.
> 
> As I said earlier, the delay was put *before* most of the data gets
> written.
> 
> More specifically, I inserted a delay of one second between transmission of
> magic1 and magic2, one between magic2 and magic3, and one between magic3
> and the first firmware file.
> 
> If I additionally insert a one-second delay before the fd is closed, I get
> this usbmon log:
> http://stuff.onse.fi/gobi2000/gobi-regression5.mon.log
> 
> The firmware upload is still unsuccessful.

If I use the option driver instead of qcserial, the firmware upload is always 
successful (without any added delays needed). The usbmon log for that case can 
be found here:
http://stuff.onse.fi/gobi2000/gobi-regression6.mon.log

-- 
Anssi Hannula
