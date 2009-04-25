Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZDYHr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZDYHr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 03:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZDYHru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 03:47:50 -0400
Received: from smtp.nokia.com ([192.100.122.230]:27858 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZDYHru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 03:47:50 -0400
Subject: Re: [PATCH] Add armflash support for multiple blocks of flash
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20090423164110.31264.42300.stgit@pc1117.cambridge.arm.com>
References: <20090423164110.31264.42300.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Apr 2009 10:47:05 +0300
Message-Id: <1240645625.22645.93.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Apr 2009 07:47:07.0865 (UTC) FILETIME=[08A78C90:01C9C57A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-23 at 17:41 +0100, Catalin Marinas wrote:
> This patch adds MTD concatenation support to integrator-flash.c for
> platforms with more than one block of flash memory (e.g. RealView
> PB11MPCore). The implementation is based on the sa1100-flash.c one.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: David Woodhouse <dwmw2@infradead.org>

I've added your patch to l2-mtd-2.6.git with Russell's Ack.
This means that it will probably be pulled to the mtd-2.6.git
tree at some point.

http://git.infradead.org/users/dedekind/l2-mtd-2.6.git?a=commit;h=62e7c70ea2b8d99c3d39bd64a937408a239cb1bb

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

