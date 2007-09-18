Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbXIRTIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbXIRTIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXIRTIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:08:01 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4121 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbXIRTIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:08:00 -0400
X-Server-Uuid: 20144BB6-FB76-4F11-80B6-E6B2900CA0D7
Subject: Re: bnx2 dirver's firmware images
From: "Michael Chan" <mchan@broadcom.com>
To: "David Miller" <davem@davemloft.net>
cc: vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
       "netdev" <netdev@vger.kernel.org>
In-Reply-To: <20070918.112337.74737433.davem@davemloft.net>
References: <200709181823.26429.vda.linux@googlemail.com>
 <1190141114.9540.216.camel@dell>
 <20070918.112337.74737433.davem@davemloft.net>
Date: Tue, 18 Sep 2007 13:05:51 -0700
Message-ID: <1190145951.9540.230.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6AEEFD884VK583310-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 11:23 -0700, David Miller wrote:

> I don't like it because it means people have to setup full initrd's
> in order to do network booting with such network cards.
> 
> But the days of my opinion mattering on that issue are long gone,
> the momentum is just too greatly behind using request_firmware()
> across the board, so there is no reason for bnx2 to be any different.
> 

The bnx2 firmware changes quite frequently.  A new driver quite often
requires new firmware to work correctly.  Splitting them up makes things
difficult for the user.

The firmware in tg3 is a lot more mature and I don't expect it to
change.  I think tg3 is better suited for using request_firmware().

