Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYLGNPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYLGNPO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 08:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYLGNO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 08:14:59 -0500
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:29627 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753716AbYLGNO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 08:14:58 -0500
X-Greylist: delayed 855 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Dec 2008 08:14:53 EST
Message-ID: <493BC885.5030303@gentoo.org>
Date: Sun, 07 Dec 2008 12:58:45 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081121)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Luca Santarelli <hrk@users.sourceforge.net>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bluetooth usb hci: ISSC usb dongle with buggy SCO  support
References: <200812050002.13560.hrk@users.sourceforge.net> <20081207001953.c04b9357.akpm@linux-foundation.org>
In-Reply-To: <20081207001953.c04b9357.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=WaEaZwtaEUEA:10 a=ZJJWXgA7zaAA:10 a=CA_98U1x7jVTNyy4ClYA:9 a=oGLi0UGOv9h41VJa3RAA:7 a=Q7mRd7eBB0-3o7eGobZjc7WaLrkA:4 a=kJVaTwQnZmMA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> commit 12421b40b81d101d7535e03f1af197365adc932b
> Author: Marcel Holtmann <marcel@holtmann.org>
> Date:   Sun Nov 30 12:17:21 2008 +0100
> 
>     Bluetooth: Remove deprecated hci_usb driver
>     
>     The old hci_usb driver has been fully replaced with the new btusb driver
>     and all major distributions switched to the new driver now. This removes
>     it since it should not be used at all anymore.
> 
> so please confirm that btusb correctly supports that hardware?

And if it doesn't, it should be trivial to come up with an equivalent 
patch to modify blacklist_table in btusb.

Daniel

