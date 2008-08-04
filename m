Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbYHDWJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbYHDWJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYHDWIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:08:53 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:53599 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYHDWIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:08:52 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Alfred E. Heggestad" <aeh@db.org>
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset #2
Date: Tue, 5 Aug 2008 00:08:48 +0200
User-Agent: KMail/1.9.9
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200806271424.50425.oliver@neukum.org> <200808041356.57928.oliver@neukum.org> <489767D3.6070408@db.org>
In-Reply-To: <489767D3.6070408@db.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808050008.48846.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 04 August 2008 22:34:27 schrieb Alfred E. Heggestad:
> > 
> > Looks like urb_irq is not properly initialised. Is there really nothing in the syslog?
> > Please print out urb->interval
> > 
> 
> urb->interval == 32
> 
> I added some more debugging in the driver, and after the module is loaded,
> I press "TAB" in a shell to force Bell/Buzzer.

Can you printk the interval and the dev pointer in 
cm109_urb_irq_callback?

	Regards
		Oliver
