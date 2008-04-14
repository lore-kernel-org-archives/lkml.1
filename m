Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbYDNUYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbYDNUYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYDNUYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:24:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYDNUYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:24:11 -0400
Date: Mon, 14 Apr 2008 17:22:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: linuxcbon <linuxcbon@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, Video <video4linux-list@redhat.com>
Subject: Re: RE : Re: Question about Creative Webcam Pro PD1030 ? Bug ?
Message-ID: <20080414172208.3b20e53d@areia>
In-Reply-To: <483029.85409.qm@web26113.mail.ukl.yahoo.com>
References: <20080412135207.79f7fce1@areia>
	<483029.85409.qm@web26113.mail.ukl.yahoo.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.1; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I forgot to cc the linux mailing list, so here it is again.

The better is to copy V4L mailing list.

> hi Mauro,
> 
> thanks for your answer !
> 
> I already contacted the authors (Mark,Wallac,Olawlor), but no feedback
> yet.
> 
> I got no oops message from kernel.

So, this doesn't seem to be a driver issue. I suspect that your userspace app
is trying to configure an unsupported configuration. This driver still
implements the legacy V4L1 API. Maybe converting it to V4L2 would solve your
issues. Another option is to check if gspca driver works with this device.

Cheers,
Mauro
