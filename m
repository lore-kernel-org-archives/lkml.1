Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYHDL5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYHDL5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 07:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYHDL5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 07:57:05 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:53695 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYHDL5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 07:57:01 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Alfred E. Heggestad" <aeh@db.org>
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset #2
Date: Mon, 4 Aug 2008 13:56:57 +0200
User-Agent: KMail/1.9.9
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200806271424.50425.oliver@neukum.org> <200807262045.22722.oliver@neukum.org> <48962B8A.8030307@db.org>
In-Reply-To: <48962B8A.8030307@db.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808041356.57928.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 04 August 2008 00:04:58 schrieb Alfred E. Heggestad:
> Oliver Neukum wrote:
> > Am Samstag 26 Juli 2008 17:55:35 schrieb Alfred E. Heggestad:
> >> Jul 26 17:32:33 io kernel: hald-addon-keyb[23629]: segfault at 6f6f6c5f ip b7e9855b sp bf9d89dc error 4 in libc-2.6.1.so[b7e28000+144000]
> >> Jul 26 17:32:43 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22
> >> Jul 26 17:33:21 io last message repeated 6 times
> >> Jul 26 17:34:28 io last message repeated 17 times
> > 
> > This should not happen. Please provide more context. If possible
> > recompile your kernel with CONFIG_USB_DEBUG.
> > 
> 
> Hi Oliver
> 
> sorry for the delay, I was out travelling with no access to CM109 hardware..
> 
> I recompiled the latest kernel from input-branch with CONFIG_USB_DEBUG enabled,
> the version reported is 2.6.27-rc1. Below you can see the syslog and the
> context of events:

Looks like urb_irq is not properly initialised. Is there really nothing in the syslog?
Please print out urb->interval

	Regards
		Oliver
