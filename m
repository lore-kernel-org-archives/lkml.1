Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbZJ1CZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbZJ1CZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 22:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932385AbZJ1CZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 22:25:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39856
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932366AbZJ1CZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 22:25:30 -0400
Date: Tue, 27 Oct 2009 19:25:53 -0700 (PDT)
Message-Id: <20091027.192553.83746115.davem@davemloft.net>
To: airlied@gmail.com
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@gmail.com>
Date: Wed, 28 Oct 2009 11:22:18 +1000

> Is there really no way to avoid compat ioctls? was I delusional in
> thinking there was?

If you use pointers in your interfaces in any way, no.

And for this drm_radeon_info thing the pointer is "pointless",
you're just returning 32-bit values to the user, just use
a u32 inside of the drm_radeon_info structure for the kernel
to place the result in.
