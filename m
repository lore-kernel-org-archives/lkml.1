Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbXEQOvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbXEQOvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbXEQOvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:51:40 -0400
Received: from smtp.nokia.com ([131.228.20.170]:28352 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbXEQOvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:51:40 -0400
Subject: Re: [PATCH] ubi: kill homegrown endian macros
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070517143200.GA30850@lst.de>
References: <20070517143200.GA30850@lst.de>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 17 May 2007 17:50:43 +0300
Message-Id: <1179413443.3642.49.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 17 May 2007 14:50:44.0321 (UTC) FILETIME=[BF2A3510:01C79892]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

On Thu, 2007-05-17 at 16:32 +0200, Christoph Hellwig wrote:
> Kill ubis homegrown endianess handling crap and replace it with
> the normal kernel endianess handling.

Err,__be32 and the company are just sparse things, while I have compiler
checks with my struct ubi32_t and friends. JFFS2 also uses the same
technique. Why do you force me to rely on sparse instead instead of
compiler?

Well, I see the good side of your change - no home-brewed media<->cpu
things. Fair enough and nice. But why don't you make __be32 a struct
(just like I do) so that compiler could complain then?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

