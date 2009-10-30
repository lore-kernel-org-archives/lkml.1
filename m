Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbZJ3AaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbZJ3AaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbZJ3AaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:30:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49905
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756041AbZJ3AaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:30:05 -0400
Date: Thu, 29 Oct 2009 17:30:28 -0700 (PDT)
Message-Id: <20091029.173028.248393897.davem@davemloft.net>
To: hancockrwd@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: update Kconfig text to mark as deprecated
From: David Miller <davem@davemloft.net>
In-Reply-To: <51f3faa70910291719kecb5edcp3b8812981b69acb1@mail.gmail.com>
References: <4AE64FCC.4030102@gmail.com>
	<20091029.031344.102288703.davem@davemloft.net>
	<51f3faa70910291719kecb5edcp3b8812981b69acb1@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Hancock <hancockrwd@gmail.com>
Date: Thu, 29 Oct 2009 18:19:03 -0600

> I think people would be better off just updating their fstab and being
> done with it.. preferably switching to something like mounting by
> label or UUID so that things just work even if the devices get
> reordered when they rearrange their cables or add a new controller,
> etc. Every Fedora/Red Hat-derived OS has set things up this way by
> default for years..

You can't just make devices dissapear without providing some
kernel option or similar that keeps things working.

My very own machines will break unless that happens.

And yes I absolutely do consider it too onerous to change my fstab
because I have to (or want to be able to) go back to older kernels
which will only have the IDE stack enabled.  I refuse to have to
monkey around with my fstab every time I want to go back and forth.

And god forbid I actually want to test some -stable IDE fix on this
machine :-)

And I know I won't be the only person in this kind of situation.

So, proceeding in any other way is really a non-starter.
