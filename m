Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbXIHNim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbXIHNim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 09:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbXIHNif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 09:38:35 -0400
Received: from mail.suse.de ([195.135.220.2]:32929 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbXIHNie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 09:38:34 -0400
Date: Sat, 8 Sep 2007 06:30:36 -0700
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>
Subject: Re: Platform device id
Message-ID: <20070908133036.GA32145@suse.de>
References: <20070907153559.17faf9d1@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070907153559.17faf9d1@hyperion.delvare>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 03:35:59PM +0200, Jean Delvare wrote:
> Hi Greg, all,
> 
> While platform_device.id is a u32, platform_device_add() handles "-1" as
> a special id value. This has potential for confusion and bugs. One such
> bug was reported to me by David Brownell:
> 
> http://lists.lm-sensors.org/pipermail/i2c/2007-September/001787.html
> 
> And since then I've found two other drivers  affected (uartlite and
> i2c-pxa).
> 
> Could we at least make platform_device.id an int so as to clear up the
> confusion? I doubt that the id will ever be a large number anyway.

Sure, that's fine by me, feel free to send a patch.

thanks,

greg k-h
