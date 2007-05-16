Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbXEPBXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbXEPBXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 21:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760450AbXEPBW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 21:22:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33570 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760321AbXEPBW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 21:22:58 -0400
Date: Wed, 16 May 2007 02:22:54 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: [PATCH] em28xx and ivtv should depend on PCI
Message-ID: <20070516012254.GF4095@ftp.linux.org.uk>
References: <E1Ho2p6-0003Tt-B7@ZenIV.linux.org.uk> <464A4163.7090509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464A4163.7090509@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 03:25:23AM +0400, Manu Abraham wrote:
> Al Viro wrote:
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> >  drivers/media/video/em28xx/Kconfig |    2 +-
> >  drivers/media/video/ivtv/Kconfig   |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/video/em28xx/Kconfig b/drivers/media/video/em28xx/Kconfig
> > index 3823b62..2c450bd 100644
> > --- a/drivers/media/video/em28xx/Kconfig
> > +++ b/drivers/media/video/em28xx/Kconfig
> > @@ -1,6 +1,6 @@
> >  config VIDEO_EM28XX
> >  	tristate "Empia EM2800/2820/2840 USB video capture support"
> > -	depends on VIDEO_V4L1 && I2C
> > +	depends on VIDEO_V4L1 && I2C && PCI
> 
> Err .. why would a USB device need to be depend on PCI ?

Because video-buf.c does.  And VIDEO_EM28XX selects it.
