Return-Path: <linux-kernel-owner+w=401wt.eu-S1946495AbXBIOvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946495AbXBIOvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 09:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946494AbXBIOvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 09:51:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42317 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946495AbXBIOvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 09:51:14 -0500
Date: Fri, 9 Feb 2007 14:51:12 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Greg KH <greg@kroah.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: device_destroy
In-Reply-To: <20070209003934.GA30794@kroah.com>
Message-ID: <Pine.LNX.4.64.0702091450120.25221@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0702081548450.7686@pentafluge.infradead.org>
 <20070209003934.GA30794@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > While porting over a few class_devices I discovered a problem with 
> > device_destroy. It uses a dev_t which several classes don't use. 
> > Should all classes require a dev_t or should we just pass in the device
> > itself?
> 
> As you don't have a dev_t, then you have a handle to the 'struct device'
> itself, right?  Then just call device_unregister(), that's all that
> device_destroy() does after it finds the device in the list of devices
> associated with the class.
> 
> Does this help?

Okay. I needed to know if calling device_unregister directly was valid.
Thank you.

