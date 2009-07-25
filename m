Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbZGYUMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbZGYUMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 16:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZGYUMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 16:12:46 -0400
Received: from www84.your-server.de ([213.133.104.84]:35613 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZGYUMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:12:46 -0400
Subject: Re: [PATCH]: fsl usb gadget driver pullup fix
From: Stefani Seibold <stefani@seibold.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
       tanya.jiang@freescale.com
In-Reply-To: <Pine.LNX.4.64.0907252141100.7825@axis700.grange>
References: <1248465623.30437.24.camel@wall-e>
	 <Pine.LNX.4.64.0907252141100.7825@axis700.grange>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 22:12:31 +0200
Message-Id: <1248552751.9674.3.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

 
Am Samstag, den 25.07.2009, 21:44 +0200 schrieb Guennadi Liakhovetski:
> Hi Stefani
> 
> On Fri, 24 Jul 2009, Stefani Seibold wrote:
> 
> > Attached is a small fix for the fsl usb gadget driver. This fix the
> > driver in a way that the usb device will be only "pulled up" on request,
> > like other usb gadget drivers do. 
> > 
> > This is necessary, because the device information is not always
> > available until an application is up and running which provides this
> > datas.
> 
> I can confirm (as well as some others), that there indeed is a problem 
> with the fsl_usb2_udc driver pullup control. If this patch fixes it - 
> great! I cannot verify its correctness by just looking at it, but I might 
> be able to test it on an i.MX31. On which hardware did you test it?
> 

i used it on a self designed mpc834x system, with is build in signal
generators from rohde & schwarz, namely the smb100a, smc100a and
smbv100a.

Regards,
Stefani


