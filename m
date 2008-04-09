Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbYDIW3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbYDIW3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 18:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYDIW3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 18:29:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54731
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752913AbYDIW3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:29:32 -0400
Date: Wed, 09 Apr 2008 15:29:33 -0700 (PDT)
Message-Id: <20080409.152933.132174258.davem@davemloft.net>
To: lkml@rtr.ca
Cc: yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <47FD138B.2060801@rtr.ca>
References: <47FCF9DD.6080007@rtr.ca>
	<20080410.023045.16227424.yoshfuji@linux-ipv6.org>
	<47FD138B.2060801@rtr.ca>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Lord <lkml@rtr.ca>
Date: Wed, 09 Apr 2008 15:05:47 -0400

> But it would be far more useful for whoever has been working on the
> stack to suggest some possible/likely commits to look at instead.

Personally all I see is that one side closes the socket before all
data packets received have been read into the application, resulting
in a (correct) reset going out.

I can't think of any change we've made over the course of this
release that would change behvaior in that area.

So you will likely need to bisect.
