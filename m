Return-Path: <linux-kernel-owner+w=401wt.eu-S1763774AbXLOLWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763774AbXLOLWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 06:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbXLOLV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 06:21:58 -0500
Received: from smtp.nokia.com ([192.100.105.134]:25186 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXLOLV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 06:21:57 -0500
Subject: Re: [PATCH] UBI: silence warning about possibly uninitialized use
	of variable in drivers/mtd/ubi/vmt.c ...
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4761b8f2.1c89420a.7f10.ffffe9db@mx.google.com>
References: <4761b8f2.1c89420a.7f10.ffffe9db@mx.google.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 15 Dec 2007 13:18:15 +0200
Message-Id: <1197717495.25999.33.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 15 Dec 2007 11:18:16.0147 (UTC) FILETIME=[303C3A30:01C83F0C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-13 at 23:53 +0100, Jesper Juhl wrote:
> From: Jesper Juhl <jesper.juhl@gmail.com>
> 
> This patch silences the following warning :
> 
>   drivers/mtd/ubi/vmt.c:73: warning: 'ret' may be used uninitialized in this function
> 
> gcc can't see that we always initialize ret in all situations where it is 
> actually used. The one case where it's not initialized is when we BUG(), 
> but gcc doesn't know that we won't then continue and use an uninitialized 
> 'ret'.
> 
> This patch results in code that does exactely the same as before, but it 
> also makes gcc shut up, so we generate one less line of warning noise.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Pushed to ubi-2.6.git, thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

