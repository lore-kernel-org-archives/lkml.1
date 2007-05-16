Return-Path: <linux-kernel-owner+w=401wt.eu-S1762653AbXEPD5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653AbXEPD5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 23:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbXEPD5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 23:57:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:60455 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbXEPD5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 23:57:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KNYlPgiGbDrShbH/2A1j0xA6H+blGUIcTbR2kk4EvN07yiCQ8Wt5ZvVeJajtvL7/jey6ghCP++CjXhmsmU1aqnds69twvVpQWCxPr5D8KGraAdjppEsZ2iuV63o9jz5Bc0mS/RYMXGXlxYQHNNQPgUiYoYlW4FbGB2uKqEI4+AA=
Message-ID: <d9def9db0705152057w50a2d69eh323c6737a0b158ca@mail.gmail.com>
Date: Wed, 16 May 2007 05:57:39 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] em28xx and ivtv should depend on PCI
Cc: "Manu Abraham" <abraham.manu@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mchehab@infradead.org
In-Reply-To: <20070516012254.GF4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1Ho2p6-0003Tt-B7@ZenIV.linux.org.uk> <464A4163.7090509@gmail.com>
	 <20070516012254.GF4095@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Wed, May 16, 2007 at 03:25:23AM +0400, Manu Abraham wrote:
> > Al Viro wrote:
> > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > ---
> > >  drivers/media/video/em28xx/Kconfig |    2 +-
> > >  drivers/media/video/ivtv/Kconfig   |    2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/media/video/em28xx/Kconfig
> b/drivers/media/video/em28xx/Kconfig
> > > index 3823b62..2c450bd 100644
> > > --- a/drivers/media/video/em28xx/Kconfig
> > > +++ b/drivers/media/video/em28xx/Kconfig
> > > @@ -1,6 +1,6 @@
> > >  config VIDEO_EM28XX
> > >  	tristate "Empia EM2800/2820/2840 USB video capture support"
> > > -	depends on VIDEO_V4L1 && I2C
> > > +	depends on VIDEO_V4L1 && I2C && PCI
> >
> > Err .. why would a USB device need to be depend on PCI ?
>
> Because video-buf.c does.  And VIDEO_EM28XX selects it.

the em28xx does not rely on video-buf, this seems to be a dependency
derived from another dependency.

Markus
