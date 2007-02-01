Return-Path: <linux-kernel-owner+w=401wt.eu-S1161233AbXBAHTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161233AbXBAHTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 02:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161238AbXBAHTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 02:19:52 -0500
Received: from smtp.nokia.com ([131.228.20.173]:43153 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161233AbXBAHTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 02:19:51 -0500
Subject: Re: [PATCH] ubi:  int versus size_t printk warnings
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1170263211.29759.334.camel@pmac.infradead.org>
References: <20070131170257.79ca59b7@localhost.localdomain>
	 <1170263211.29759.334.camel@pmac.infradead.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 01 Feb 2007 09:19:19 +0200
Message-Id: <1170314360.6275.14.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 01 Feb 2007 07:19:20.0332 (UTC) FILETIME=[4A79B4C0:01C745D1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 17:06 +0000, David Woodhouse wrote:
> > +               ubi_err("error %d while reading %Zd bytes from PEB %d:%d, "
> 
> Nak. %Zd is a gratuitous GNUism. In C, we use %zd.
> 
> Artem (dedekind) is the correct person to deal with UBI stuff. I've
> added him to Cc.

Yeah, there was a problem of mixing size_t and int in UBI and it was
mostly fixed - thanks to akpm. These are leftovers. I will look through
the code and fix things like this.

Thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

