Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbXIMWFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbXIMWFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 18:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbXIMWFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 18:05:06 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:43776 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758123AbXIMWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 18:05:04 -0400
Date: Fri, 14 Sep 2007 00:06:22 +0200
From: aherrman@arcor.de
To: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: akpm@linux-foundation.org, linux-usb-devel@lists.sourceforge.net,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l: Build error with et61x251, if V4L1_COMPAT is not selected
Message-ID: <20070913220622.GA5764@devil>
References: <20070913123627.GD10348@devil> <200709131707.16666.luca.risolia@studio.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709131707.16666.luca.risolia@studio.unibo.it>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 05:07:16PM +0200, Luca Risolia wrote:
> On Thursday 13 September 2007 14:36:27 aherrman@arcor.de wrote:
> > With current git tree I get an build error
> > for et61x251, if V4L1_COMPAT is not selected:
> >
> > drivers/media/video/et61x251/et61x251_core.c: In et61x251_show_:
> > drivers/media/video/et61x251/et61x251_core.c:718: error: implicit
> > declaration of to_video_device
> >
> > Fix: add VIDEO_V4L1_COMPAT as a dependency for this driver.
> 
> No, wait. The driver really is V4L2 only. If you can, please fix it by 
> replacing to_video_device() with container_of() instead:
> 
> cam = video_get_drvdata(container_of(cd, struct video_device, class_dev));

Ah just some v4l1 remainders.
I'll do that.


Regards,

Andreas

