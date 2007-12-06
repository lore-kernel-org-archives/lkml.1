Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbXLFCTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbXLFCTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXLFCTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:19:37 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:11388 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXLFCTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:19:36 -0500
Message-ID: <47575C07.1080001@oracle.com>
Date: Wed, 05 Dec 2007 18:18:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, jengelh@computergmbh.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reduce stack used by lib/hexdump.c
References: <1196359724.22120.22.camel@localhost>	 <20071129102400.dac158d8.randy.dunlap@oracle.com>	 <1196361860.22120.27.camel@localhost> <474F0A68.1080809@oracle.com>	 <1196369873.22120.69.camel@localhost> <474F28EB.20608@oracle.com>	 <Pine.LNX.4.64.0711292206450.3089@fbirervta.pbzchgretzou.qr>	 <1196378922.22120.72.camel@localhost>	 <20071205160133.0766c4f5.akpm@linux-foundation.org> <1196907017.10819.49.camel@localhost>
In-Reply-To: <1196907017.10819.49.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2007-12-05 at 16:01 -0800, Andrew Morton wrote:
>> You could trim linebuf[] to 80 chars or so.  Extra points for making it
>> very clear when someone tries to exceed that - strcpy(linebuf, "stop being
>> stupid").
> 
> Maybe just eliminate the 16 or 32 byte width option and
> force it to only 16 byte widths.
> 
> That'd keep it down to ~ 100 bytes nicely.
> 
> Prefix + address + dump + ascii: 20 + 18 + 48 + 10.

Have you checked users (callers)?  I'm pretty sure that one of the
callers wanted 32 and that's why it's there.


-- 
~Randy
Features and documentation: http://lwn.net/Articles/260136/
