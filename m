Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbYEPDAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbYEPDAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 23:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYEPDAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 23:00:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50885 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYEPDAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 23:00:10 -0400
Date: Thu, 15 May 2008 23:59:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Dean Anderson <dean@sensoray.com>
Cc: Trent Piepho <xyzzy@speakeasy.org>, Greg KH <greg@kroah.com>,
       Markus Rechberger <mrechberger@gmail.com>, video4linux-list@redhat.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] USB: add Sensoray 2255 v4l driver
Message-ID: <20080515235954.53e29d6c@gaivota>
In-Reply-To: <482C5812.9090903@sensoray.com>
References: <20080514205927.GA13134@kroah.com>
	<d9def9db0805141817n4182deedp780791b0a51fb7be@mail.gmail.com>
	<20080515024141.GB21941@kroah.com>
	<Pine.LNX.4.58.0805142006130.23876@shell4.speakeasy.net>
	<482C5812.9090903@sensoray.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Since planar YUV formats such as V4L2_PIX_FMT_YUV422P are still not that 
> well supported, is it possible to keep at least one packed YUV 
> format(V4L2_PIX_FMT_YUYV) in the driver?  If not, let me know.  I will 
> strongly suggest that the hardware Engineers add YUY2 or YUYV on board 
> in the DSP firmware.  Thanks, Dean

The better is to have YUY2 and YUYV formats at the firmware and/or hardware.
Those are the more common formats, and userspace apps generally try one of
those first. Also, as it is common on several devices, the userspace handlers
are more tested.

Cheers,
Mauro
