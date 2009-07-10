Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbZGJMDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbZGJMDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbZGJMDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:03:06 -0400
Received: from smtp.nokia.com ([192.100.122.230]:30126 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZGJMDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:03:05 -0400
Subject: Re: [PATCH 2:2][MTD][NAND]omap : Adding DMA mode support in nand 
 prefetch/post-write
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: vimal singh <vimalsingh@ti.com>
Cc: linux-mtd@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
       dwmw2@infradead.org, david-b@pacbell.net, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
In-Reply-To: <63362.192.168.10.89.1247226916.squirrel@dbdmail.itg.ti.com>
References: <63362.192.168.10.89.1247226916.squirrel@dbdmail.itg.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jul 2009 15:02:24 +0300
Message-Id: <1247227344.20721.363.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Jul 2009 12:02:26.0142 (UTC) FILETIME=[4A741FE0:01CA0156]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 17:25 +0530, vimal singh wrote:
> +	/* The fifo depth is 64 bytes. We have a sync at each frame and frame
> +	 * length is 64 bytes.
> +	 */
> +	int buf_len = len/64;

To optimize performance it is better not to rely on gcc and use <<

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

