Return-Path: <linux-kernel-owner+w=401wt.eu-S1764946AbXIMDzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764946AbXIMDzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 23:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763205AbXIMDyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 23:54:20 -0400
Received: from mylar.outflux.net ([69.93.193.226]:41663 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762855AbXIMDyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 23:54:19 -0400
Date: Wed, 12 Sep 2007 20:54:07 -0700
From: Kees Cook <kees@ubuntu.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Ben Collins <bcollins@ubuntu.com>
Subject: Re: [PATCH] usb: fix unterminated usn_device_id lists
Message-ID: <20070913035407.GN8183@outflux.net>
References: <20070913004709.GL8183@outflux.net> <46E88F1B.5050405@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E88F1B.5050405@garzik.org>
Organization: Ubuntu
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 12, 2007 at 09:15:07PM -0400, Jeff Garzik wrote:
>> +	{ 0, },
>
> FWIW I (and several drivers) tend to prefer the more clean version,
>
> 	{ },
>
> or even
>
> 	{ },	/* terminate list */

Ah, yes.  I see that now in some of the other drivers.  Should I re-send
this patch (and/or the other PCI patches)?

Thanks,

-Kees

-- 
Kees Cook
