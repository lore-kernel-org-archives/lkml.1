Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbXEJIKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbXEJIKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758755AbXEJIK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:10:28 -0400
Received: from smtp.nokia.com ([131.228.20.173]:36347 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbXEJIKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:10:25 -0400
Subject: Re: [PATCH] fix memory leak in UBI scanning unit
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, dedekind@linutronix.de
In-Reply-To: <200705100026.12639.jesper.juhl@gmail.com>
References: <200705100026.12639.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 10 May 2007 11:09:33 +0300
Message-Id: <1178784573.3734.5.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 10 May 2007 08:09:50.0006 (UTC) FILETIME=[94C8C560:01C792DA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 00:26 +0200, Jesper Juhl wrote:
> In drivers/mtd/ubi/scan.c::paranoid_check_si() there's a memory leak.
> If the call 
> 	err = ubi_io_is_bad(ubi, pnum);
> returns <0, then we'll return with out freeing (and thus leak) buf.
> This patch eliminates the memory leak by freeing buf before returning.
> 
> Problem spotted by the Coverity checker.

It was already reported and fixed in our git tree. But thanks anyway.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

