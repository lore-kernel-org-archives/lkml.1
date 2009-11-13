Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbZKMI2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbZKMI2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZKMI2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:28:46 -0500
Received: from smtp.nokia.com ([192.100.105.134]:39852 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbZKMI2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:28:45 -0500
Subject: Re: [PATCH] mtd: error return -EIO instead of EIO
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AFB22CA.2050106@gmail.com>
References: <4AFB22CA.2050106@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 10:28:28 +0200
Message-Id: <1258100908.21596.1188.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Nov 2009 08:28:32.0433 (UTC) FILETIME=[49040A10:01CA643B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 21:47 +0100, Roel Kluin wrote:
> Return a negative error value instead of a positive
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/mtd/maps/physmap.c    |    2 +-
>  drivers/mtd/maps/vmu-flash.c  |    2 +-
>  drivers/mtd/nand/atmel_nand.c |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)

Taken to my l2-mtd-2.6.git tree, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

