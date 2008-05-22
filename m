Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbYEVRmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbYEVRmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYEVRlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:41:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52066
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753476AbYEVRlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:41:50 -0400
Date: Thu, 22 May 2008 10:41:45 -0700 (PDT)
Message-Id: <20080522.104145.193700531.davem@davemloft.net>
To: jesper@krogh.cc
Cc: Matheos.Worku@Sun.COM, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4835A007.7020601@krogh.cc>
References: <4824D1E1.10007@sun.com>
	<20080509.154538.28321777.davem@davemloft.net>
	<4835A007.7020601@krogh.cc>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Krogh <jesper@krogh.cc>
Date: Thu, 22 May 2008 18:32:07 +0200

> Does this mean that I can expect every 10G card to have this limitation
> under Linux?

For now, yes.  The transmit path itself in the generic network
device layer is where the serialization comes from.

I'm travelling now for 3 weeks so I won't be able to work on
this stuff until I get back.
