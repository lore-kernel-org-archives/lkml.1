Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab0CCXF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:05:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42803 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab0CCXFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:05:23 -0500
Message-ID: <4B8EEB2D.4090106@zytor.com>
Date: Wed, 03 Mar 2010 15:05:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Daniel Taylor <Daniel.Taylor@wdc.com>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msdos: add support for large disks
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com><20100301141335.395dc4c3.akpm@linux-foundation.org> <873a0h1p2c.fsf@devron.myhome.or.jp> <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD53@wdscexbe01.sc.wdc.com>
In-Reply-To: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD53@wdscexbe01.sc.wdc.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 02:50 PM, Daniel Taylor wrote:
> 
> The drives report physical/logical sector sizes of 4096 bytes, which the
> kernel correctly detects.  32-bit fields in the MBR are then sufficient for
> storage capacites >2TiB (up to 16 TiB), and the storage in struct
> parsed_partitions is already sector_t.
> 

It's probably worth noting that such media:

a) will not work with anything that is based on disk images;
b) will not be bootable on most existing systems.

Both of these are going to be issues for people in real-life use (and
yes, people boot from USB disks -- trust me, when it doesn't work they
send the bug reports to *me* rather than to the hw/bios vendors.)  Of
course, so is XP compatibility.

	-hpa
