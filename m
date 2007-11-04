Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbXKDUaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbXKDUaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 15:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbXKDU35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 15:29:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40874 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbXKDU35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 15:29:57 -0500
Subject: Re: device struct bloat
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071103124823.6059640e@shemminger-laptop>
References: <20071103124823.6059640e@shemminger-laptop>
Content-Type: text/plain
Date: Sun, 04 Nov 2007 21:29:18 +0100
Message-Id: <1194208158.5911.63.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-11-03 at 12:48 -0700, Stephen Hemminger wrote:
> The sizeof(struct device) is way too big, especially in the network device case.
> We want to support 1000's of device's and the change from class_device to
> net_device has caused needless bloat.
> 
> sizeof(struct device) = 272
> sizeof(struct class_device) = 92
>   * not the class_id in class_device could also be removed or changed to
>      a ptr, since it is redundant for net_devices.

The thing that surprised me most was that it contains a struct
semaphore, Greg, is that really needed?



