Return-Path: <linux-kernel-owner+w=401wt.eu-S1762621AbYD3LRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621AbYD3LRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbYD3LRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:17:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45456
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757206AbYD3LRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:17:05 -0400
Date: Wed, 30 Apr 2008 04:17:03 -0700 (PDT)
Message-Id: <20080430.041703.89847530.davem@davemloft.net>
To: tiwai@suse.de
Cc: mingo@elte.hu, mchehab@infradead.org, akpm@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de
Subject: Re: [patch, -git] media/video/sound build fix, TEA5761/TEA5767
From: David Miller <davem@davemloft.net>
In-Reply-To: <s5hiqxzwqak.wl%tiwai@suse.de>
References: <20080430110115.GA5633@elte.hu>
	<s5hiqxzwqak.wl%tiwai@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>
Date: Wed, 30 Apr 2008 13:11:31 +0200

> IMO, it's the reverse selection from sound to V4L that makes things
> complicated.  I believe it's better to fix it as a normal dependency.
> 
> How about the patch below?

The question that remains is what does this mean for users?

How does a user, who wants to enable this 'sound' driver,
learn that they must enable the v4l subsystem in order to
do so?

This is typically why select constructs are used, to not bother the
user with such messy details.

But like we see in this case, it can cause serious implementation
problems if not used properly. :(
