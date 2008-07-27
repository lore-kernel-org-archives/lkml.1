Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbYG0XOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbYG0XOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 19:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYG0XOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 19:14:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47318
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbYG0XOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 19:14:33 -0400
Date: Sun, 27 Jul 2008 16:14:32 -0700 (PDT)
Message-Id: <20080727.161432.237385384.davem@davemloft.net>
To: rdreier@cisco.com
Cc: alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, kkeil@suse.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
From: David Miller <davem@davemloft.net>
In-Reply-To: <adamyk35aoi.fsf@cisco.com>
References: <20080727182709.1dac0556@lxorguk.ukuu.org.uk>
	<20080727.125604.73857337.davem@davemloft.net>
	<adamyk35aoi.fsf@cisco.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 27 Jul 2008 13:33:49 -0700

>  > IMHO, this driver was really rushed in and that was a huge mistake.
>  > If it had gone through linux-next we could have tidied all of this
>  > stuff up in a less "rushed" manner.
> 
> ??  This thread *is* about a build failure in linux-next.

The driver went directly into Linus's tree.

Stephen hit the build problem once he synced linux-next up with
Linus's current tree.
