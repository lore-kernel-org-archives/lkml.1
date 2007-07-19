Return-Path: <linux-kernel-owner+w=401wt.eu-S1763501AbXGSUyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763501AbXGSUyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758652AbXGSUys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:54:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51563
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757485AbXGSUys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:54:48 -0400
Date: Thu, 19 Jul 2007 13:54:47 -0700 (PDT)
Message-Id: <20070719.135447.112263535.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: airlied@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Re: cmpxchg is not available to generic code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070719012141.47911bd7.akpm@linux-foundation.org>
References: <20070719.002716.30181989.davem@davemloft.net>
	<21d7e9970707190115r15e691d5s123c9889a8ebd8a5@mail.gmail.com>
	<20070719012141.47911bd7.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 19 Jul 2007 01:21:41 -0700

> On Thu, 19 Jul 2007 18:15:03 +1000 "Dave Airlie" <airlied@gmail.com> wrote:
> 
> > Maybe we could add CONFIG_HAVE_CMPXCHG and let DRM depend on it..
> 
> That would certainly be better than adding a sprinkle of architectures
> in DRM Kconfig dependencies.
> 
> I don't know how important DRM is on ARM.  Zero?

We already have EMULATED_CMPXCHG guarding DRM.
