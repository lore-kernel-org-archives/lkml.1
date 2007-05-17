Return-Path: <linux-kernel-owner+w=401wt.eu-S1761204AbXEQVdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbXEQVdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbXEQVdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:33:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52306
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754972AbXEQVdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:33:32 -0400
Date: Thu, 17 May 2007 14:33:34 -0700 (PDT)
Message-Id: <20070517.143334.38710608.davem@davemloft.net>
To: dmitry.torokhov@gmail.com
Cc: viro@ftp.linux.org.uk, akpm@linux-foundation.org, dedekind@infradead.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] ubi: kill homegrown endian macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <d120d5000705171414u55af4c03m6e6d2fbcf982e3ff@mail.gmail.com>
References: <20070517102931.6bbbad1a.akpm@linux-foundation.org>
	<20070517204234.GR4095@ftp.linux.org.uk>
	<d120d5000705171414u55af4c03m6e6d2fbcf982e3ff@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Date: Thu, 17 May 2007 17:14:26 -0400

> On 5/17/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> >
> > Ahem...  So what does
> >        x |= y;
> > turns into with that approach?
> 
> Do we want to do such kind of operations on endian-annotated data? I'd
> imagine you want to convert ot host-endianess first anyway.

Generally you don't, if 'x' and 'y' are both in the needed
endinaness already, there is no reason to convert anything.
