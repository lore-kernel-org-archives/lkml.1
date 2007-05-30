Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbXE3PrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbXE3PrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbXE3Pq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:46:56 -0400
Received: from smtp.nokia.com ([131.228.20.173]:50297 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbXE3Pq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:46:56 -0400
Message-ID: <465D9C62.4070009@yandex.ru>
Date: Wed, 30 May 2007 18:46:42 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Daniel Hazelton <dhazelton@enter.net>,
       Michael-Luke Jones <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, dwmw2@infradead.org
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression
 support - take 6)
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>	 <a781481a0705290427n3bad472aqf4e0b8276780b405@mail.gmail.com>	 <231C137C-D0BF-44F7-B2D5-AE610284D00A@cam.ac.uk>	 <200705290943.11176.dhazelton@enter.net> <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com> <465D7EFB.8090609@yandex.ru>
In-Reply-To: <465D7EFB.8090609@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 May 2007 15:46:42.0697 (UTC) FILETIME=[B8487790:01C7A2D1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> JFFS2 needs: it has _big_ input buffer, and _small_ output buffer, and 
> it wants
> zlib to compress as much as possible from the input buffer, and make the 
> output
> buffer full or nearly full of compressed data.
 
Err, and important note is that it also wants this compressed data to be
independently uncompressable.


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
