Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbZJ1DiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbZJ1DiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbZJ1DiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:38:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40367
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359AbZJ1DiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:38:14 -0400
Date: Tue, 27 Oct 2009 20:38:38 -0700 (PDT)
Message-Id: <20091027.203838.21218679.davem@davemloft.net>
To: airlied@gmail.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com>
	<87hbtkjkki.fsf@basil.nowhere.org>
	<21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@gmail.com>
Date: Wed, 28 Oct 2009 13:05:08 +1000

> DrNick on irc suggested just doing:
> if (is_compat_task()) ptr &= 0x00000000FFFFFFFF;
> 
> Is there a one liner I can just do in the actual ioctls instead of
> adding 20 compat
> ones?

Just do the right thing and pass all userland compat pointers
through the correct compat_*() macros.
