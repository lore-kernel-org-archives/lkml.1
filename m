Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbXEQU4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbXEQU4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXEQU4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:56:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50284
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754136AbXEQU4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:56:24 -0400
Date: Thu, 17 May 2007 13:56:24 -0700 (PDT)
Message-Id: <20070517.135624.131107441.davem@davemloft.net>
To: dedekind@infradead.org
Cc: hch@lst.de, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: kill homegrown endian macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <1179413443.3642.49.camel@sauron>
References: <20070517143200.GA30850@lst.de>
	<1179413443.3642.49.camel@sauron>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <dedekind@infradead.org>
Date: Thu, 17 May 2007 17:50:43 +0300

> Well, I see the good side of your change - no home-brewed media<->cpu
> things. Fair enough and nice. But why don't you make __be32 a struct
> (just like I do) so that compiler could complain then?

structs get passed on the stack instead of via registers, regardless
of size, when passed as arguments on some architectures, so there is a
terrible performance cost of doing things that way
