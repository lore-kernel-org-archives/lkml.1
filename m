Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbZE1P2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbZE1P2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbZE1P2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:28:24 -0400
Received: from smtp.nokia.com ([192.100.105.134]:27666 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbZE1P2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:28:23 -0400
Subject: Re: [PATCH 1/3] mtd/maps: uclinux: allow systems to override map
 addr/size
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Paul Mundt <lethal@linux-sh.org>, linux-mtd@lists.infradead.org,
       uclinux-dev@uclinux.org, Greg Ungerer <gerg@uclinux.org>
In-Reply-To: <1243380798-10089-1-git-send-email-vapier@gentoo.org>
References: <20090526231902.GA6295@linux-sh.org>
	 <1243380798-10089-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 May 2009 18:26:27 +0300
Message-Id: <1243524387.11172.64.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 May 2009 15:26:36.0711 (UTC) FILETIME=[B0995B70:01C9DFA8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 19:33 -0400, Mike Frysinger wrote:
> Due to a processor anomaly (05000263 to be exact), most Blackfin parts
> cannot keep the embedded filesystem image directly after the kernel in
> RAM.  Instead, the filesystem needs to be relocated to the end of memory.
> As such, we need to tweak the map addr/size during boot for Blackfin
> systems.  This can be done in any early arch/board init code.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Paul Mundt <lethal@linux-sh.org>
> CC: Greg Ungerer <gerg@uclinux.org>
> CC: uclinux-dev@uclinux.org
> CC: linux-mtd@lists.infradead.org
> ---
>  drivers/mtd/maps/uclinux.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)

I've added your patches to my tree.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

