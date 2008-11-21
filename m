Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbYKUOfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbYKUOfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 09:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYKUOez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 09:34:55 -0500
Received: from sour.ops.eusc.inter.net ([84.23.254.154]:50383 "EHLO
	sour.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbYKUOey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 09:34:54 -0500
X-Greylist: delayed 1465 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Nov 2008 09:34:54 EST
Message-ID: <4926C153.3090104@gmx.de>
Date: Fri, 21 Nov 2008 15:10:27 +0100
From: Cord Walter <cord.walter@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Komuro <komurojun-mbn@nifty.com>
CC: netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: axnet_cs / pcnet_cs: moving PCMCIA_DEVICE_PROD_ID for Netgear
 FA411
References: <4925F6F1.9010305@gmx.de> <20081121214812.b03d7166.komurojun-mbn@nifty.com>
In-Reply-To: <20081121214812.b03d7166.komurojun-mbn@nifty.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Komuro schrieb:
> On Fri, 21 Nov 2008 00:46:57 +0100
> Cord Walter <cord.walter@gmx.de> wrote:
> 
>> after noticing that my Netgear FA411 (PCMCIA-NIC) [1] stopped working with
>> the release of the 2.6.25 kernel (sidux-version),
> 
> You are right. My patch has a bug.
> The patch below fixes this problem.
> 
> By the way,
> (1) Does your FA411 work properly with the pcnet_cs driver before?

Yes, it worked until the 2.6.25 release.

> (2) Please post the full-dmesg (axnet_cs).

This is what I get from dmesg when plugging in the FA411:

pccard: PCMCIA card inserted into slot 1
cs: memory probe 0xa0000000-0xa0ffffff: clean.
pcmcia: registering new device pcmcia1.0
eth0: Asix AX88790: io 0x300, irq 3, hw_addr 00:09:5b:08:98:93
udev: renamed network interface eth0 to eth1
NET: Registered protocol family 17


Does this help?

-cord

-- 
Cord Walter
email: cord.walter@gmx.de

Weil es niemanden etwas angeht, dass ich nichts zu verbergen habe:
http://www.gnupg.org/
http://www.truecrypt.org/
...und überhaupt: http://www.FreiheitstattAngst.de
