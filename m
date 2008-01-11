Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbYAKIap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbYAKIap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758249AbYAKIaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:30:35 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:37392 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251AbYAKIad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:30:33 -0500
Date: Fri, 11 Jan 2008 09:30:27 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Bill Gribble <grib@billgribble.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2 libertas_sdio fails to initialize Marvell SD8686
Message-ID: <20080111093027.6bf61af6@poseidon.drzeus.cx>
In-Reply-To: <87y7ayvkq1.fsf@billgribble.com>
References: <87bq9x264q.fsf@serrano.home.billgribble.com>
	<20071114190247.4f42aa05@poseidon.drzeus.cx>
	<87y7ayvkq1.fsf@billgribble.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jan 2008 14:53:58 -0500
Bill Gribble <grib@billgribble.com> wrote:

> 
> Any other sage advice?  I feel like the device is really close to
> working, but I just can't get it there!  
>

Since you're having problems with the very first part, I'm not sure I'd agree with your assessment. ;)

The fact is that the libertas chips are extremely moody, and Marvell has the weird attitude that there is one driver and one firmware per board/implementation, not per chip model. So friction is bound to appear when we try to have a generic driver that supports all of these different revisions.

So that means there's two options for you right now; experiment wildly and hope you get lucky and find how to avoid whatever bug your particular chip has, or try to get information from Marvell or Raon about how to interface with the chip.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
