Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbZEFMK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbZEFMK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbZEFMKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:10:42 -0400
Received: from smtp.mppmu.mpg.de ([134.107.24.58]:56162 "EHLO
	smtp.mppmu.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249AbZEFMKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:10:41 -0400
X-Greylist: delayed 1637 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2009 08:10:40 EDT
Date: Wed, 6 May 2009 13:43:18 +0200 (CEST)
From: Peter Breitenlohner <peb@mppmu.mpg.de>
To: Robert Schwebel <r.schwebel@pengutronix.de>
cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [PATCH] fix blkid.h include
In-Reply-To: <20090506113550.GQ15802@pengutronix.de>
Message-ID: <alpine.LNX.1.10.0905061338460.18351@pcl321.mppmu.mpg.de>
References: <20090505214214.GC4460@nb.net.home> <20090506113550.GQ15802@pengutronix.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Robert Schwebel wrote:

> The reason is that blkid.h comes from e2fsutils, which install the header file
> into /usr/include/blkid/blkid.h; /usr/include is also what the .pc file
> specifies for the include path for the CFLAGS. ...

But not for blkid.h from e2fsprogs-1.41.3 where 'pkg-config blkid --cflags'
yields "-I/usr/include/blkid -I/usr/include/uuid  ".

Regards
Peter Breitenlohner <peb@mppmu.mpg.de>
