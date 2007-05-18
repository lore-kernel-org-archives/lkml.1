Return-Path: <linux-kernel-owner+w=401wt.eu-S1762381AbXERHAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762381AbXERHAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977AbXERG7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:59:54 -0400
Received: from smtp.nokia.com ([131.228.20.173]:33717 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbXERG7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:59:53 -0400
Message-ID: <464D4E91.1000000@yandex.ru>
Date: Fri, 18 May 2007 09:58:25 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, dedekind@infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
References: <20070517143200.GA30850@lst.de> <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de> <1179414590.3642.69.camel@sauron> <20070517102931.6bbbad1a.akpm@linux-foundation.org> <20070517204234.GR4095@ftp.linux.org.uk> <20070517205339.GS4095@ftp.linux.org.uk>
In-Reply-To: <20070517205339.GS4095@ftp.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 18 May 2007 06:58:26.0163 (UTC) FILETIME=[EEB83430:01C79919]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> BTW, you can simply typedef __be16 ubi16_t; etc. and define conversion
> functions as cpu_to_ubi16(x) being (__force ubi16_t)cpu_to_be16(x), etc.
> 
> sparse will do all checks just fine, you still have bitwise operations
> (might or might be not relevant in your case) and for gcc it simply
> becomes __be16, etc - i.e. an integer type.

Err, what is the benefit of it? If we relied on sparce, why not would we be
just using __be16 directly?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
