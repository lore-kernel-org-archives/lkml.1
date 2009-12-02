Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZLBWcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZLBWcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZLBWcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:32:23 -0500
Received: from smtp.nokia.com ([192.100.122.230]:49588 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbZLBWcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:32:23 -0500
Date: Thu, 3 Dec 2009 00:31:56 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091202223156.GA14921@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
 <20091202173321.GA23738@nokia.com>
 <6ed0b2680912021234x6b5e6058p6d50d5cd20ecf019@mail.gmail.com>
 <20091202204946.GB25682@nokia.com>
 <6ed0b2680912021329g372bd0a4vb5b4a80244960f95@mail.gmail.com>
 <20091202215442.GA30658@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20091202215442.GA30658@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Dec 2009 22:32:12.0548 (UTC) FILETIME=[4ACDDC40:01CA739F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 02, 2009 at 10:54:42PM +0100, ext Anton Vorontsov wrote:
>As for the default USB VBUS current value, it could be Kconfig
>option (something alike to USB_GADGET_VBUS_DRAW) and/or module
>parameter, or hw default, or hardcoded for now. Either will
>work.

cannot be Kconfig, it's mandated by usb battery charging spec 1.x to be 
100mA for 100ms, then if you don't enumerate, you have to cut charging.

>
>-- 
>Anton Vorontsov
>email: cbouatmailru@gmail.com
>irc://irc.freenode.net/bd2

-- 
balbi
