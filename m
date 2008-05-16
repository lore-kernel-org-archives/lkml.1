Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbYEPSSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbYEPSSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbYEPSRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:17:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44706 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbYEPSRx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:17:53 -0400
Date: Fri, 16 May 2008 15:17:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: dean <dean@sensoray.com>
Cc: Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       v4l-dvb-maintainer@linuxtv.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
Message-ID: <20080516151718.15de1b9b@gaivota>
In-Reply-To: <482DAEDB.70702@sensoray.com>
References: <20080514205927.GA13134@kroah.com>
	<20080515235102.756407d3@gaivota>
	<200805160828.13856.oliver@neukum.org>
	<482DAEDB.70702@sensoray.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dean,

On Fri, 16 May 2008 08:57:15 -0700
dean <dean@sensoray.com> wrote:

> Hi Oliver,
> 
> Just to be clear.  You mean fixing the loading issues(ugly msleep, 
> etc...) that Mauro mentioned, not the YUV formats(which seem unrelated)? 
> 
> Would it be ok to have just 422P and greyscale in the driver for now if 
> we can't get a firmware update in a reasonable timeframe? It's certainly 
> not ideal, but we could direct our customers to the libraries, at least 
> until we get a proper HW fix.

Feature regression is something that shouldn't happen. If we add the driver
with a color conversion inside, we should somehow keep this feature available
on newer versions. That's said, I don't see any issue if the later versions do
this implementation inside hardware/firmware, since the end result is that the
driver will keep supporting those standards.

>From my side, I'm ok on having this color conversion for a short timeframe (one
or two kernel releases), if you are sure that those features will be present
on the next firmwares.

The better is to mark the driver as EXPERIMENTAL, at Kconfig.

Cheers,
Mauro
